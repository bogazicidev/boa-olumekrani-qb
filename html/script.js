// Prevent multiple script loading
if (window.BOADeathScreenLoaded) {
    console.log('BOA Death Screen: Script already loaded, skipping...');
    throw new Error('Script already loaded');
}
window.BOADeathScreenLoaded = true;

// Safe resource name getter
function getResourceName() {
    if (typeof GetParentResourceName === 'function') {
        return GetParentResourceName();
    }
    // Fallback resource name
    return 'BOA-OlumEkrani';
}

let countdownInterval;
let currentTime = 300; // 5 minutes in seconds
let isDeathScreenActive = false; // Track if death screen is currently active
let emergencyCooldownInterval; // Emergency cooldown countdown
let emergencyCooldownTime = 0; // Emergency cooldown remaining time

// Listen for messages from Lua
window.addEventListener('message', async function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'showDeathScreen':
            await showDeathScreen(data.data);
            break;
        case 'hideDeathScreen':
            hideDeathScreen();
            break;
        case 'updateTimer':
            updateTimer(data.data.time);
            break;
        case 'emergencyCooldown':
            showEmergencyCooldown(data.data.remainingTime);
            break;
        case 'updateKillerName':
            updateKillerName(data.data);
            break;
    }
});

async function showDeathScreen(data) {
    const deathScreen = document.getElementById('deathScreen');
    const killerName = document.getElementById('killer-name');
    
    if (!deathScreen || !killerName) {
        return;
    }
    
    // Update UI texts from config first
    await updateUITexts();
    
    // Set killer name
    killerName.textContent = data.killedBy || 'Bilinmeyen';
    
    // Reset timer
    currentTime = 300;
    updateTimerDisplay(currentTime);
    
    // Show death screen
    deathScreen.classList.remove('hidden');
    isDeathScreenActive = true;
    
    // Start countdown
    startCountdown();
}

async function updateUITexts() {
    
    // Update UI texts from config
    const elements = [
        {id: 'coming-soon', key: 'ui_coming_soon'},
        {id: 'bleeding-out', key: 'ui_bleeding_out'},
        {id: 'ambulance-wait', key: 'ui_ambulance_wait'},
        {id: 'call-emergency', key: 'ui_call_emergency'},
        {id: 'killed-by-text', key: 'ui_killed_by'}
    ];
    
    // Try to get config texts
    const promises = elements.map(async element => {
        const el = document.getElementById(element.id);
        if (!el) return;
        
        try {
            const response = await fetch(`https://${getResourceName()}/getConfigText`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    key: element.key,
                    params: []
                })
            });
            
            const data = await response.json();
            if (data && data.text) {
                el.textContent = data.text;
            }
        } catch (error) {
            console.log('Failed to get config text for:', element.key, error);
        }
    });
    
    // Wait for all config text requests to complete
    await Promise.all(promises);
}

function hideDeathScreen() {
    const deathScreen = document.getElementById('deathScreen');
    
    if (!deathScreen) {
        return;
    }
    
    deathScreen.classList.add('hidden');
    isDeathScreenActive = false;
    
    // Stop countdown
    if (countdownInterval) {
        clearInterval(countdownInterval);
        countdownInterval = null;
    }
    
    // Stop emergency cooldown
    if (emergencyCooldownInterval) {
        clearInterval(emergencyCooldownInterval);
        emergencyCooldownInterval = null;
    }
    
    // Hide cooldown message
    const cooldownMessage = document.getElementById('cooldownMessage');
    if (cooldownMessage) {
        cooldownMessage.classList.add('hidden');
    }
}

function startCountdown() {
    if (countdownInterval) {
        clearInterval(countdownInterval);
    }
    
    countdownInterval = setInterval(() => {
        if (!isDeathScreenActive) {
            clearInterval(countdownInterval);
            return;
        }
        
        currentTime--;
        updateTimerDisplay(currentTime);
        
        if (currentTime <= 0) {
            clearInterval(countdownInterval);
            // Player bled out
            fetch(`https://${getResourceName()}/playerBledOut`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            }).catch(() => {});
        }
    }, 1000);
}

function updateTimer(time) {
    currentTime = time;
    updateTimerDisplay(currentTime);
}

function updateTimerDisplay(seconds) {
    const countdownElement = document.getElementById('countdown');
    if (!countdownElement) {
        return;
    }
    
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    const display = `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    
    countdownElement.textContent = display;
}

function showEmergencyCooldown(remainingSeconds) {
    // Show cooldown message in the designated area
    const cooldownMessage = document.getElementById('cooldownMessage');
    if (!cooldownMessage) {
        return;
    }
    
    // Set initial cooldown time
    emergencyCooldownTime = remainingSeconds;
    
    // Show cooldown message - Get from config
    fetch(`https://${getResourceName()}/getConfigText`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            key: 'ui_cooldown_message',
            params: [remainingSeconds]
        })
    }).then(response => response.json()).then(data => {
        cooldownMessage.textContent = data.text;
        cooldownMessage.classList.remove('hidden');
    }).catch(() => {
        // Fallback message - Turkish
        cooldownMessage.textContent = `Hastaneye bildirim gitti! Tekrar bildirim için ${remainingSeconds} saniye bekleyin!`;
        cooldownMessage.classList.remove('hidden');
    });
    
    // Start countdown timer
    if (emergencyCooldownInterval) {
        clearInterval(emergencyCooldownInterval);
    }
    
    emergencyCooldownInterval = setInterval(() => {
        emergencyCooldownTime--;
        
        if (emergencyCooldownTime <= 0) {
            // Cooldown finished
            clearInterval(emergencyCooldownInterval);
            cooldownMessage.classList.add('hidden');
        } else {
            // Update cooldown message - Get from config
            fetch(`https://${getResourceName()}/getConfigText`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    key: 'ui_cooldown_message',
                    params: [emergencyCooldownTime]
                })
            }).then(response => response.json()).then(data => {
                cooldownMessage.textContent = data.text;
            }).catch(() => {
                // Fallback message - Turkish
                cooldownMessage.textContent = `Hastaneye bildirim gitti! Tekrar bildirim için ${emergencyCooldownTime} saniye bekleyin!`;
            });
        }
    }, 1000);
}

function updateKillerName(data) {
    const killerName = document.getElementById('killer-name');
    if (!killerName) {
        return;
    }
    
    killerName.textContent = data.killedBy || 'Bilinmeyen';
}

// Button event listeners
document.addEventListener('DOMContentLoaded', function() {
    const acceptDeathBtn = document.getElementById('acceptDeath');
    const callEmergencyBtn = document.getElementById('callEmergency');
    
    if (acceptDeathBtn) {
        acceptDeathBtn.addEventListener('click', function() {
            fetch(`https://${getResourceName()}/acceptDeath`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            }).catch(() => {});
        });
    }
    
    if (callEmergencyBtn) {
        callEmergencyBtn.addEventListener('click', function() {
            fetch(`https://${getResourceName()}/callEmergency`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            }).catch(() => {});
        });
    }
});

// Prevent context menu
document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
});

// Prevent text selection
document.addEventListener('selectstart', function(e) {
    e.preventDefault();
});


