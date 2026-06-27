const API = '/api/medicines';

async function fetchAndRender(url, title = 'All Medicines', showAlert = false) {
  try {
    const res = await fetch(url);
    const medicines = await res.json();
    renderTable(medicines, title, showAlert);
  } catch {
    document.getElementById('medicineBody').innerHTML =
      '<tr><td colspan="8" class="empty-row">Failed to load data. Is the server running?</td></tr>';
  }
}

async function loadMedicines() {
  hideBanner();
  const name = document.getElementById('searchInput').value.trim();
  const url = name ? `${API}?name=${encodeURIComponent(name)}` : API;
  await fetchAndRender(url, name ? `Results for "${name}"` : 'All Medicines');
  await loadStats();
}

async function loadLowStock() {
  hideBanner();
  await fetchAndRender(`${API}/low-stock`, 'Low Stock Medicines', true);
}

function onSearchInput() {
  const name = document.getElementById('searchInput').value.trim();
  if (!name) { loadMedicines(); return; }
  fetchAndRender(`${API}?name=${encodeURIComponent(name)}`, `Results for "${name}"`);
}

async function loadStats() {
  try {
    const [all, low] = await Promise.all([
      fetch(API).then(r => r.json()),
      fetch(`${API}/low-stock`).then(r => r.json())
    ]);
    document.getElementById('statTotal').textContent = all.length;
    document.getElementById('statLow').textContent   = low.length;
    document.getElementById('statOk').textContent    = all.length - low.length;
    const cats = new Set(all.map(m => m.category)).size;
    document.getElementById('statCats').textContent  = cats;
  } catch { /* silently fail */ }
}

function renderTable(medicines, title, showAlert) {
  document.getElementById('tableTitle').textContent = title;
  document.getElementById('tableCount').textContent =
    `${medicines.length} item${medicines.length !== 1 ? 's' : ''}`;

  const banner = document.getElementById('alertBanner');
  if (showAlert && medicines.length > 0) {
    banner.innerHTML = `${medicines.length} medicine${medicines.length > 1 ? 's are' : ' is'} below the minimum stock threshold.`;
    banner.classList.remove('hidden');
  }

  const tbody = document.getElementById('medicineBody');
  if (medicines.length === 0) {
    tbody.innerHTML = '<tr><td colspan="8" class="empty-row">No medicines found.</td></tr>';
    return;
  }

  tbody.innerHTML = medicines.map(m => {
    const isLow = m.quantity < m.threshold;
    return `
      <tr>
        <td>${m.id}</td>
        <td class="med-name">${m.name}</td>
        <td><span class="cat-badge">${m.category}</span></td>
        <td class="qty-text">${m.quantity} <span style="color:#9ca3af;font-size:0.8rem">${m.unit}</span></td>
        <td>${m.threshold}</td>
        <td><span class="badge ${isLow ? 'low' : 'ok'}">${isLow ? 'Low Stock' : 'In Stock'}</span></td>
        <td>
          <div class="adjust-form">
            <input type="number" id="adj-${m.id}" placeholder="±qty" />
            <button onclick="adjustStock(${m.id})">Update</button>
          </div>
        </td>
        <td><button class="btn-delete" onclick="deleteMedicine(${m.id})">Delete</button></td>
      </tr>`;
  }).join('');
}

async function adjustStock(id) {
  const input = document.getElementById(`adj-${id}`);
  const adjustment = parseInt(input.value);
  if (isNaN(adjustment)) return alert('Enter a valid number, e.g. 10 or -5');

  const res = await fetch(`${API}/${id}/adjust`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ adjustment })
  });

  if (res.ok) { input.value = ''; loadMedicines(); }
  else alert('Failed to update stock.');
}

async function deleteMedicine(id) {
  if (!confirm('Are you sure you want to delete this medicine?')) return;
  const res = await fetch(`${API}/${id}`, { method: 'DELETE' });
  if (res.ok) loadMedicines();
  else alert('Failed to delete medicine.');
}

function openModal() {
  document.getElementById('modalOverlay').classList.remove('hidden');
}

function closeModal() {
  document.getElementById('modalOverlay').classList.add('hidden');
  document.querySelector('.modal-form').reset();
}

function closeModalOutside(e) {
  if (e.target.id === 'modalOverlay') closeModal();
}

async function submitAddMedicine(e) {
  e.preventDefault();
  const medicine = {
    name:      document.getElementById('fName').value.trim(),
    category:  document.getElementById('fCategory').value.trim(),
    quantity:  parseInt(document.getElementById('fQuantity').value),
    threshold: parseInt(document.getElementById('fThreshold').value),
    unit:      document.getElementById('fUnit').value.trim()
  };
  const res = await fetch(API, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(medicine)
  });
  if (res.ok) { closeModal(); loadMedicines(); }
  else alert('Failed to add medicine.');
}

function hideBanner() {
  document.getElementById('alertBanner').classList.add('hidden');
}

function setActive(el) {
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
  el.classList.add('active');
}

// Init
loadMedicines();
