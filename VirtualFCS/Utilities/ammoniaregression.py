import numpy as np
import matplotlib.pyplot as plt

# Obtain Shomate parameters for liquid ammonia
# See e.g. gaseous ammonia on NIST for the formulas:
# https://webbook.nist.gov/cgi/cbook.cgi?ID=C7664417&Units=SI&Mask=1#Thermo-Gas

M = 17.031E-3 # kg/mol
T = np.array([195.5] + list(range(200, 401, 10)) + [405.4])
t = T / 1000.0
n = len(T)
k = 3 # Last items dropped in cp due to divergence to infinity

h  = np.array([-1110.1, -1088.8, -1044.1, -1000.6, -957.0,
               -912.9, -868.2, -823.1, -777.3, -730.9,
               -683.8, -636.0, -587.2, -537.5, -486.7,
               -434.3, -380.0, -323.2, -262.6, -196.5,
               -120.9, -23.5, 142.7]) * M # kJ/mol
s  = np.array([4.203, 4.311, 4.529, 4.731, 4.925,
               5.113, 5.294, 5.471, 5.643, 5.811,
               5.975, 6.135, 6.293, 6.448, 6.602,
               6.755, 6.908, 7.063, 7.222, 7.391,
               7.578, 7.813, 8.216])*M*1000 # J/(K.mol)
cp = np.array([4.73, 4.61, 4.38, 4.35, 4.38,
               4.43, 4.48, 4.54, 4.60, 4.66,
               4.73, 4.82, 4.91, 5.02, 5.17,
               5.37, 5.64, 6.04, 6.68, 7.80,
               10.3, 21, float('inf')])[:-k]*M*1000      # J/(K.mol)

# Design matrix columns: A, B, C, D, E, F, G (H?)
X_h  = np.column_stack([t, t**2/2, t**3/3, t**4/4, -1/t,
                        np.ones(n), np.zeros(n)])
X_s  = np.column_stack([np.log(t), t, t**2/2, t**3/3, -1/(2*t**2),
                        np.zeros(n), np.ones(n)])
X_cp = np.column_stack([np.ones(n-k), t[:-k], t[:-k]**2, t[:-k]**3,
                        1/t[:-k]**2, np.zeros(n-k), np.zeros(n-k)])

# Weighting: normalize each series by its own scale so residuals
# are comparable regardless of units. Std dev is a reasonable default;
# swap for known measurement uncertainty if you have it.
w_cp = 1.0 / cp.std()
w_h  = 1.0 / h.std()
w_s  = 1.0 / s.std()

X = np.vstack([X_cp * w_cp, X_h * w_h, X_s * w_s])
y = np.concatenate([cp * w_cp, h * w_h, s * w_s])

coeffs, residuals, rank, sv = np.linalg.lstsq(X, y, rcond=None)
A, B, C, D, E, F, G = coeffs
n, p = X.shape

resid = y - X @ coeffs
dof = n - p                      # degrees of freedom: 29 data points - 7 params
sigma2 = np.sum(resid**2) / dof  # residual variance estimate

cov = sigma2 * np.linalg.inv(X.T @ X)
param_std = np.sqrt(np.diag(cov))

for name, val, err in zip("ABCDEFG", coeffs, param_std):
    print(f"{name} = {val:.6g}  ±  {err/abs(val)*100:.3f}%")

T_plot = np.linspace(195.5, 405.4, 300)
t_plot = T_plot / 1000.0

cp_fit = A + B*t_plot + C*t_plot**2 + D*t_plot**3 + E/t_plot**2
h_fit  = A*t_plot + B*t_plot**2/2 + C*t_plot**3/3 + D*t_plot**4/4 - E/t_plot + F
s_fit  = A*np.log(t_plot) + B*t_plot + C*t_plot**2/2 + D*t_plot**3/3 - E/(2*t_plot**2) + G

fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))

axes[0].scatter(T[:-k], cp, s=20, color='black', label='data', zorder=3)
axes[0].plot(T_plot, cp_fit, color='C0', label='Shomate fit')
axes[0].set_xlabel('T (K)')
axes[0].set_ylabel('cp (J/(mol·K))')
axes[0].set_title('Heat capacity')
axes[0].legend()

axes[1].scatter(T, h, s=20, color='black', label='data', zorder=3)
axes[1].plot(T_plot, h_fit, color='C1', label='Shomate fit')
axes[1].set_xlabel('T (K)')
axes[1].set_ylabel('h (kJ/mol)')
axes[1].set_title('Enthalpy')
axes[1].legend()

axes[2].scatter(T, s, s=20, color='black', label='data', zorder=3)
axes[2].plot(T_plot, s_fit, color='C2', label='Shomate fit')
axes[2].set_xlabel('T (K)')
axes[2].set_ylabel('s (J/(mol·K))')
axes[2].set_title('Entropy')
axes[2].legend()

for ax in axes:
    ax.axvline(298.15, color='gray', linestyle=':', linewidth=1)  # reference T, if using NIST H/F convention

plt.tight_layout()
plt.show()


# The enthalpy reference needs to be consistent with NIST data used for gas phase
H = -45.90 - 22.7 # Std Enthalpy of formation of gas - std enthalpy of vaporisation
t = 298/1000
F -= A*t + B*t**2/2 + C*t**3/3 + D*t**4/4 - E/t + F - H
print('Corrected F and H to align with NIST convention:')
print(f'F={F:.3f} kJ/mol, H={H:.3f} kJ/mol')

# Same goes with entropy
G = 192.77 - 22700/298.15 - (A*np.log(t) + B*t + C*t**2/2 + D*t**3/3 - E/(2*t**2))
print('Corrected G to align with NIST convention:')
print(f'G={G:.3f} J/mol K')


