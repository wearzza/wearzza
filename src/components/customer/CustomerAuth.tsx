import { useState } from 'react';
import { useCustomer } from '../../contexts/CustomerContext';
import { X, User, Mail, Phone, Lock } from 'lucide-react';

interface Props {
  onClose: () => void;
}

export default function CustomerAuth({ onClose }: Props) {
  const { login, signup, customer, logout } = useCustomer();
  const [mode, setMode] = useState<'login' | 'signup'>('login');
  const [form, setForm] = useState({ name: '', phone: '', email: '', password: '' });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function submit() {
    setError('');
    setLoading(true);
    if (mode === 'login') {
      const r = await login(form.email, form.password);
      if (!r.ok) setError(r.error || 'Login failed');
      else onClose();
    } else {
      if (!form.name || !form.phone || !form.email || !form.password) { setError('Please fill all fields'); setLoading(false); return; }
      const r = await signup(form.name, form.phone, form.email, form.password);
      if (!r.ok) setError(r.error || 'Signup failed');
      else onClose();
    }
    setLoading(false);
  }

  if (customer) {
    return (
      <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4" onClick={onClose}>
        <div className="bg-white rounded-3xl max-w-sm w-full p-6 text-center" onClick={e => e.stopPropagation()}>
          <div className="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center" style={{ background: '#ff3b3015' }}>
            <User size={28} style={{ color: '#ff3b30' }} />
          </div>
          <h2 className="text-lg font-black text-gray-900 mb-1">{customer.name}</h2>
          <p className="text-sm text-gray-400 mb-6">{customer.email}</p>
          <button onClick={() => { logout(); onClose(); }} className="w-full py-3 rounded-xl font-bold text-sm border border-gray-200 text-gray-600 hover:bg-gray-50 transition-colors">Logout</button>
          <button onClick={onClose} className="w-full py-3 mt-2 rounded-xl font-bold text-sm text-white" style={{ background: '#ff3b30' }}>Continue Shopping</button>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div className="bg-white rounded-3xl max-w-sm w-full p-6" onClick={e => e.stopPropagation()}>
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-lg font-black text-gray-900">{mode === 'login' ? 'Login' : 'Create Account'}</h2>
          <button onClick={onClose} className="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-100"><X size={18} className="text-gray-500" /></button>
        </div>
        <p className="text-xs text-gray-400 mb-4">Optional - you can also checkout as a guest. Login to track your orders easily.</p>

        <div className="space-y-3">
          {mode === 'signup' && (
            <>
              <div>
                <label className="text-xs font-medium text-gray-600 mb-1 flex items-center gap-1.5"><User size={12} /> Full Name</label>
                <input value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} className="w-full px-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-red-400" />
              </div>
              <div>
                <label className="text-xs font-medium text-gray-600 mb-1 flex items-center gap-1.5"><Phone size={12} /> Phone</label>
                <input type="tel" value={form.phone} onChange={e => setForm({ ...form, phone: e.target.value })} placeholder="98XXXXXXXX" className="w-full px-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-red-400" />
              </div>
            </>
          )}
          <div>
            <label className="text-xs font-medium text-gray-600 mb-1 flex items-center gap-1.5"><Mail size={12} /> Email</label>
            <input type="email" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} className="w-full px-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-red-400" />
          </div>
          <div>
            <label className="text-xs font-medium text-gray-600 mb-1 flex items-center gap-1.5"><Lock size={12} /> Password</label>
            <input type="password" value={form.password} onChange={e => setForm({ ...form, password: e.target.value })} onKeyDown={e => e.key === 'Enter' && submit()} className="w-full px-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-red-400" />
          </div>
          {error && <p className="text-xs text-red-500">{error}</p>}
          <button onClick={submit} disabled={loading} className="w-full py-3.5 rounded-xl font-bold text-white text-sm disabled:opacity-50" style={{ background: 'linear-gradient(135deg, #ff3b30, #e8251a)' }}>{loading ? 'Please wait...' : mode === 'login' ? 'Login' : 'Sign Up'}</button>
        </div>

        <p className="text-center text-xs text-gray-500 mt-4">
          {mode === 'login' ? "Don't have an account? " : 'Already have an account? '}
          <button onClick={() => { setMode(mode === 'login' ? 'signup' : 'login'); setError(''); }} className="font-bold" style={{ color: '#ff3b30' }}>{mode === 'login' ? 'Sign up' : 'Login'}</button>
        </p>
      </div>
    </div>
  );
}
