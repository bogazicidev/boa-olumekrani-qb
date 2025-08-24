// Prevent multiple script loading
if (window.BOADeathScreenLoaded) {
    console.log('BOA Death Screen: Script already loaded, skipping...');
    throw new Error('Script already loaded');
}
window.BOADeathScreenLoaded = true;

let countdownInterval;
let currentTime = 300; // 5 minutes in seconds
let isDeathScreenActive = false; // Track if death screen is currently active

// Listen for messages from Lua
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'showDeathScreen':
            showDeathScreen(data.data);
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

function showDeathScreen(data) {
    const deathScreen = document.getElementById('deathScreen');
    const killerName = document.getElementById('killer-name');
    
    if (!deathScreen || !killerName) {
        return;
    }
    
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
            fetch(`https://${GetParentResourceName()}/playerBledOut`, {
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
    
    cooldownMessage.textContent = `Hastaneye bildirim gitti! Tekrar bildirim için ${remainingSeconds} saniye bekleyin!`;
    cooldownMessage.classList.remove('hidden');
    
    // Hide after 3 seconds
    setTimeout(() => {
        cooldownMessage.classList.add('hidden');
    }, 3000);
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
            fetch(`https://${GetParentResourceName()}/acceptDeath`, {
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
            fetch(`https://${GetParentResourceName()}/callEmergency`, {
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


