const API_BASE = "https://merge-conflict-bm7shr3cx-janhavis-projects-c55ba700.vercel.app/api";

// --- 1. CORE VARIABLES ---
const canvas = document.getElementById('physics-bg');
const ctx = canvas.getContext('2d');
const cursor = document.getElementById('cursor');
const hoverSfx = document.getElementById('hover-sfx');
const clickSfx = document.getElementById('click-sfx');

let mx = 0, my = 0; 
let cx = 0, cy = 0; 
let dots = [];

// --- 2. MATH BACKGROUND (RETAINED FROM 0.02) ---
function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    initGrid();
}

class Dot {
    constructor(x, y) {
        this.baseX = x; this.baseY = y;
        this.x = x; this.y = y;
        this.size = 1.2;
    }
    update() {
        let dx = mx - this.x;
        let dy = my - this.y;
        let distance = Math.sqrt(dx * dx + dy * dy);
        if (distance < 150) {
            let force = (150 - distance) / 150;
            this.x -= (dx / distance) * force * 15;
            this.y -= (dy / distance) * force * 15;
        } else {
            this.x += (this.baseX - this.x) * 0.08;
            this.y += (this.baseY - this.y) * 0.08;
        }
    }
    draw() {
        ctx.fillStyle = 'rgba(0, 212, 255, 0.3)';
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
    }
}

function initGrid() {
    dots = [];
    for (let x = 0; x < canvas.width; x += 40) {
        for (let y = 0; y < canvas.height; y += 40) {
            dots.push(new Dot(x, y));
        }
    }
}

function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Lighting Math
    const gradient = ctx.createRadialGradient(mx, my, 0, mx, my, 300);
    gradient.addColorStop(0, 'rgba(0, 212, 255, 0.15)');
    gradient.addColorStop(1, 'transparent');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    dots.forEach(d => { d.update(); d.draw(); });

    // Cursor Lerping
    cx += (mx - cx) * 0.15;
    cy += (my - cy) * 0.15;
    cursor.style.transform = `translate(${cx}px, ${cy}px)`;

    requestAnimationFrame(animate);
}

// --- 3. WIDGET & SCROLL LOGIC (NEW) ---
const homePage = document.getElementById('home');
homePage.addEventListener('scroll', () => {
    const scrolled = homePage.scrollTop;
    const steps = document.querySelectorAll('.strategy-step');
    
    steps.forEach((step, idx) => {
        const speed = 0.1 * (idx + 1);
        // Heavy Math for float animation on scroll
        const yOffset = Math.sin(scrolled * 0.005 + idx) * 10;
        step.style.transform = `translateY(${yOffset}px)`;
        
        // Progress reveal logic
        if (scrolled > 300 + (idx * 50)) {
            step.style.opacity = "1";
            step.style.filter = "blur(0px)";
        } else {
            step.style.opacity = "0.3";
            step.style.filter = "blur(4px)";
        }
    });
});

// --- 4. NAVIGATION & SFX ---
function navTo(pageId) {
    clickSfx.currentTime = 0;
    clickSfx.play().catch(() => {});

    document.querySelectorAll('.page').forEach(p => {
        p.classList.remove('active');
        p.style.display = 'none';
    });

    const target = document.getElementById(pageId);
    target.style.display = 'block';

    setTimeout(() => {
        target.classList.add('active');

        if (pageId === "prediction") {
            loadRecommendation();        // 🔥 NEW
            renderTickerChart("ticker-chart", "^NSEI");
        }


        if (pageId === "historical") {
                loadPerformance();                 // ✅ ADD THIS

            renderBacktestChart("backtest-chart");
        }

        if (pageId === "news") {
            loadNews(); // ✅ THIS IS THE KEY
        }
    }, 50);
}


// Cursor Listeners
function initListeners() {
    document.querySelectorAll('button, .glass, .nav-btn, .strategy-step').forEach(el => {
        el.addEventListener('mouseenter', () => {
            hoverSfx.currentTime = 0;
            hoverSfx.volume = 0.15;
            hoverSfx.play().catch(()=>{});
            cursor.style.transform += " scale(4)";
            cursor.style.background = "transparent";
            cursor.style.border = "1px solid #00d4ff";
        });
        el.addEventListener('mouseleave', () => {
            cursor.style.background = "#00d4ff";
            cursor.style.border = "none";
        });
    });
}

window.addEventListener('mousemove', (e) => { mx = e.clientX; my = e.clientY; });
window.addEventListener('resize', resize);

// --- 5. CHARTS (RETAINED) ---
function initCharts() {
    const config = (color) => ({
        type: 'line',
        data: {
            labels: ['A', 'B', 'C', 'D', 'E'],
            datasets: [{ data: [10, 25, 13, 18, 30], borderColor: color, tension: 0.4, pointRadius: 0 }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: false }, scales: { x: { display: false }, y: { display: false } } }
    });
    new Chart(document.getElementById('chart1'), config('#00d4ff'));
    new Chart(document.getElementById('chart2'), config('#3b82f6'));
}
// Example logic to generate 25 cards for testing
function generateNewsCards() {
    const grid = document.getElementById('news-grid');
    if(!grid) return;

    for (let i = 1; i <= 25; i++) {
        const card = document.createElement('div');
        card.className = "news-card glass group p-5 border border-white/5 hover:border-cyan-500/50 transition-all duration-300 flex flex-col justify-between h-48 relative overflow-hidden";
        
        // Setting unique IDs and timestamps for each card
        card.innerHTML = `
            <div>
                <div class="flex justify-between items-start mb-3">
                    <span class="text-[9px] font-mono text-cyan-500 bg-cyan-500/10 px-2 py-0.5 rounded uppercase">Signal_${i}</span>
                    <span class="text-[9px] font-mono text-gray-600">${new Date().toLocaleTimeString()}</span>
                </div>
                <h3 class="text-sm font-bold text-gray-200 group-hover:text-white leading-snug transition-colors line-clamp-3">
                    Neural weights adjusted for overnight liquidity shift in market session ${i}. Data packet successfully ingested into Nocturn 0.04 kernel.
                </h3>
            </div>
            <div class="mt-4 pt-3 border-t border-white/5 flex justify-between items-center">
                <span class="text-[10px] text-cyan-600 font-mono">NODE_00${i}</span>
                <span class="text-cyan-400 opacity-0 group-hover:opacity-100 transition-opacity">→</span>
            </div>
        `;
        
        grid.appendChild(card);
    }
    
    // Refresh hover listeners so these new cards react to the cursor and sound
    initListeners(); 
}

// BOOTSTRAP VISUALS (safe immediately)
resize();
animate();
initListeners();
//generateNewsCards();

async function loadNews() {
    const grid = document.getElementById("news-grid");
    if (!grid) return;

    grid.innerHTML = ""; // clear old cards

    try {
        const res = await fetch(`${API_BASE}/news`);
        const data = await res.json();

        data.articles.forEach((article, idx) => {
            const card = document.createElement("div");
            card.className =
                "news-card glass group p-5 border border-white/5 hover:border-cyan-500/50 transition-all duration-300 flex flex-col justify-between h-48 relative overflow-hidden cursor-pointer";

            card.innerHTML = `
                <div>
                    <div class="flex justify-between items-start mb-3">
                        <span class="text-[9px] font-mono text-cyan-500 bg-cyan-500/10 px-2 py-0.5 rounded uppercase">
                            ${article.source}
                        </span>
                        <span class="text-[9px] font-mono text-gray-600">
                            ${new Date(article.published_at).toLocaleTimeString()}
                        </span>
                    </div>

                    <h3 class="text-sm font-bold text-gray-200 group-hover:text-white leading-snug transition-colors line-clamp-3">
                        ${article.title}
                    </h3>

                    <p class="text-[11px] text-gray-500 mt-2 line-clamp-3">
                        ${article.preview || ""}
                    </p>
                </div>

                <div class="mt-4 pt-3 border-t border-white/5 flex justify-between items-center">
                    <span class="text-[10px] text-cyan-600 font-mono">
                        NEWS_${idx + 1}
                    </span>
                    <span class="text-cyan-400 opacity-0 group-hover:opacity-100 transition-opacity">
                        →
                    </span>
                </div>
            `;

            // Open original article on click
            card.addEventListener("click", () => {
                window.open(article.url, "_blank");
            });

            grid.appendChild(card);
        });

        initListeners(); // rebind hover sounds/cursor

    } catch (err) {
        console.error("Failed to load news", err);
        grid.innerHTML =
            "<p class='text-gray-500 text-sm'>Failed to load news.</p>";
    }
}

async function loadRecommendation() {
    const panel = document.getElementById("recommendation-panel");
    if (!panel) return;

    panel.innerHTML = "";

    try {
        const res = await fetch(`${API_BASE}/recommendation`);
        const data = await res.json();

        data.allocations.forEach((row) => {

    const action = row.CapitalAllocated > 0 ? "BUY" : "HOLD";
    const actionColor = row.CapitalAllocated > 0
        ? "text-[#00ff9d]"
        : "text-gray-400";

    const card = document.createElement("div");
    card.className =
        "glass p-6 border border-white/5 hover:border-cyan-500/50 transition-all duration-300 cursor-pointer";

    card.innerHTML = `
        <div class="flex justify-between items-center mb-3">
            <h3 class="text-xl font-bold text-cyan-400">
                ${row.Ticker}
            </h3>
            <span class="text-xs font-mono ${actionColor}">
                ${action}
            </span>
        </div>

        <div class="text-sm text-gray-300 mb-3">
            Capital Allocated:
            <span class="text-[#00ff9d] font-mono">
                ₹${(row.CapitalAllocated / 1e3).toFixed(2)}K
            </span>
        </div>

        <p class="text-xs text-gray-400 leading-relaxed">
            ${row.Explanation}
        </p>
    `;

    card.addEventListener("click", () => {
        renderTickerChart("ticker-chart", row.Ticker);
    });

    panel.appendChild(card);
});


        initListeners();

    } catch (err) {
        console.error("Failed to load recommendation", err);
        panel.innerHTML =
            "<p class='text-gray-500 text-sm'>Failed to load recommendation.</p>";
    }
}

async function loadPerformance() {
    try {
        const res = await fetch(`${API_BASE}/performance`);
        const data = await res.json();

        document.getElementById("cagr-value").textContent =
            `${data.cagr.toFixed(2)}%`;

        document.getElementById("maxdd-value").textContent =
            `${data.max_drawdown.toFixed(2)}%`;

        document.getElementById("sharpe-value").textContent =
            data.sharpe.toFixed(2);

    } catch (err) {
        console.error("Failed to load performance", err);
    }
}
