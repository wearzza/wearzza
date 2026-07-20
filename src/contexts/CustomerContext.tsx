import { createContext, useContext, useState, useCallback, ReactNode, useEffect } from 'react';
import { supabase, Customer } from '../lib/supabase';
import { hashPassword, verifyPassword } from '../lib/auth';

interface CustomerCtx {
  customer: Customer | null;
  login: (email: string, password: string) => Promise<{ ok: boolean; error?: string }>;
  signup: (name: string, phone: string, email: string, password: string) => Promise<{ ok: boolean; error?: string }>;
  logout: () => void;
}

const Ctx = createContext<CustomerCtx | null>(null);

const STORAGE_KEY = 'wearza_customer';

export function CustomerProvider({ children }: { children: ReactNode }) {
  const [customer, setCustomer] = useState<Customer | null>(null);

  useEffect(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      try { setCustomer(JSON.parse(saved)); } catch { /* ignore */ }
    }
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    const { data } = await supabase.from('customers').select('*').eq('email', email).maybeSingle();
    if (!data) return { ok: false, error: 'No account found with this email' };
    if (!verifyPassword(password, data.password_hash)) return { ok: false, error: 'Incorrect password' };
    const c = data as Customer;
    setCustomer(c);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(c));
    return { ok: true };
  }, []);

  const signup = useCallback(async (name: string, phone: string, email: string, password: string) => {
    const { data: existing } = await supabase.from('customers').select('id').eq('email', email).maybeSingle();
    if (existing) return { ok: false, error: 'An account with this email already exists' };
    const { data, error } = await supabase.from('customers').insert({
      name, phone, email, password_hash: hashPassword(password),
    }).select().single();
    if (error || !data) return { ok: false, error: 'Failed to create account' };
    const c = data as Customer;
    setCustomer(c);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(c));
    return { ok: true };
  }, []);

  const logout = useCallback(() => {
    setCustomer(null);
    localStorage.removeItem(STORAGE_KEY);
  }, []);

  return <Ctx.Provider value={{ customer, login, signup, logout }}>{children}</Ctx.Provider>;
}

export function useCustomer() {
  const c = useContext(Ctx);
  if (!c) throw new Error('useCustomer must be used within CustomerProvider');
  return c;
}
