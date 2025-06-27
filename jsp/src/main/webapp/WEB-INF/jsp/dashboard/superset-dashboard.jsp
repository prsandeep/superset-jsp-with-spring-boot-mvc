<%-- src/main/webapp/WEB-INF/jsp/dashboard/superset-dashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TTS Dashboard - biDarshan Analytics</title>

    <!-- Include axios for HTTP requests -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.0/axios.min.js"></script>

    <!-- Include Superset Embedded SDK -->
    <script src="https://unpkg.com/@superset-ui/embedded-sdk@0.1.0-alpha.10/bundle/index.js"></script>

    <style>
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            overflow: hidden; /* Prevent scrollbars */
        }

        .container {
            height: 100vh;
            width: 100vw;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 20px; /* Reduced padding for more space */
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: relative;
            flex-shrink: 0; /* Prevent header from shrinking */
            z-index: 1000;
        }

        .header h1 {
            margin: 0;
            font-size: 22px; /* Slightly smaller for more space */
            font-weight: 300;
            display: inline-block;
        }

        .header .subtitle {
            margin: 3px 0 0 0;
            font-size: 13px;
            opacity: 0.9;
        }

        .header .user-info {
            position: absolute;
            top: 12px;
            right: 20px;
            font-size: 11px;
            opacity: 0.8;
        }

        /* FULL SCREEN DASHBOARD WRAPPER */
        .dashboard-wrapper {
            flex: 1; /* Take all remaining space */
            position: relative;
            overflow: hidden;
            background: white;
            /* REMOVED: margin, border-radius, box-shadow for full screen */
            height: calc(100vh - 70px); /* Subtract header height */
        }

        /* FULL SCREEN DASHBOARD CONTAINER */
        #dashboard-container {
            height: 100%;
            width: 100%;
            /* REMOVED: border-radius for full screen */
            overflow: hidden;
        }

        /* FORCE SUPERSET DASHBOARD TO FULL SIZE */
        #dashboard-container iframe {
            width: 100% !important;
            height: 100% !important;
            border: none !important;
            margin: 0 !important;
            padding: 0 !important;
        }

        /* FORCE ALL SUPERSET ELEMENTS TO FULL SIZE */
        #dashboard-container .superset-embedded-sdk-container {
            width: 100% !important;
            height: 100% !important;
        }

        /* OVERRIDE ANY SUPERSET RESPONSIVE CONSTRAINTS */
        #dashboard-container [class*="dashboard"] {
            width: 100% !important;
            height: 100% !important;
            max-width: none !important;
            min-width: 100% !important;
        }

        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            text-align: center;
            z-index: 1000;
            min-width: 300px;
        }

        .error {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.98);
            color: #d32f2f;
            padding: 30px;
            border-radius: 12px;
            border: 2px solid #ffcdd2;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            z-index: 1000;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-text {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .loading-subtitle {
            font-size: 13px;
            color: #666;
        }

        .retry-btn, .config-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            margin: 8px 5px 0;
            font-size: 13px;
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .retry-btn:hover, .config-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        .config-info {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-family: monospace;
            z-index: 100;
            max-width: 300px;
        }

        .progress-bar {
            width: 100%;
            height: 3px;
            background-color: #e0e0e0;
            border-radius: 2px;
            margin: 15px 0;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2px;
            width: 0%;
            animation: progress 3s ease-in-out;
        }

        @keyframes progress {
            0% { width: 0%; }
            30% { width: 30%; }
            60% { width: 60%; }
            100% { width: 100%; }
        }

        /* HIDE SCROLLBARS IN DASHBOARD */
        #dashboard-container::-webkit-scrollbar {
            display: none;
        }
        #dashboard-container {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        /* RESPONSIVE DESIGN */
        @media (max-width: 768px) {
            .header {
                padding: 10px 15px;
            }

            .header h1 {
                font-size: 20px;
            }

            .header .user-info {
                position: static;
                margin-top: 8px;
                font-size: 10px;
            }

            .dashboard-wrapper {
                height: calc(100vh - 80px); /* Adjust for mobile header */
            }

            .loading, .error {
                margin: 10px;
                max-width: calc(100% - 20px);
                padding: 25px 15px;
            }
        }

        /* MOBILE LANDSCAPE */
        @media (max-width: 768px) and (orientation: landscape) {
            .header {
                padding: 8px 15px;
            }

            .header .subtitle {
                display: none; /* Hide subtitle in mobile landscape */
            }

            .dashboard-wrapper {
                height: calc(100vh - 50px); /* Less header height in landscape */
            }
        }

        /* SMALL SCREENS - HIDE SOME ELEMENTS FOR MORE SPACE */
        @media (max-height: 600px) {
            .header .subtitle {
                display: none;
            }

            .dashboard-wrapper {
                height: calc(100vh - 45px);
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>TTS Dashboard</h1>
        <p class="subtitle">biDarshan Analytics Integration</p>
        <div class="user-info">
            User: ${username} | Environment: ${environment}
        </div>
    </div>

    <div class="dashboard-wrapper">
        <!-- Configuration info (only in development) -->
        <c:if test="${environment == 'development'}">
            <div class="config-info" id="config-info">
                Dashboard: <span id="dashboard-id-display">${dashboardId}</span>
            </div>
        </c:if>

        <!-- Loading indicator -->
        <div id="loading-indicator" class="loading">
            <div class="spinner"></div>
            <div class="loading-text">Loading Dashboard</div>
            <div class="loading-subtitle">Connecting to biDarshan...</div>
            <div class="progress-bar">
                <div class="progress-fill"></div>
            </div>
        </div>

        <!-- Error message -->
        <div id="error-message" class="error" style="display: none;">
            <h3>⚠️ Dashboard Load Error</h3>
            <p id="error-text">Failed to load dashboard</p>
            <div>
                <button class="retry-btn" onclick="embedSupersetDashboard()">🔄 Retry</button>
                <a href="${pageContext.request.contextPath}/dashboard/config" class="config-btn">⚙️ Configuration</a>
            </div>
        </div>

        <!-- FULL SCREEN DASHBOARD CONTAINER -->
        <div id="dashboard-container"></div>
    </div>
</div>

<script>
    // Enhanced Configuration for Full Screen Display
    const CONFIG = {
        dashboardId: '${dashboardId}',
        supersetUrl: '${supersetUrl}',
        backendUrl: '${pageContext.request.contextPath}/api/superset/guest-token',
        environment: '${environment}',
        dashboardUiConfig: {
            hideTitle: true, // Hide dashboard title for more space
            hideChartControls: false, // Keep chart controls
            hideTab: true, // Hide tab bar for cleaner look
            filters: {
                expanded: false,
                visible: true
            },
            // FORCE FULL SIZE CONFIGURATION
            urlParams: {
                standalone: '1', // Enable standalone mode
                height: 'auto',
                width: 'auto'
            }
        }
    };

    // State management
    let isLoading = true;
    let currentError = null;
    let retryCount = 0;
    const MAX_RETRIES = 3;

    // DOM elements
    let loadingIndicator;
    let errorMessage;
    let errorText;
    let dashboardContainer;

    // Initialize when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        console.log('🚀 TTS Dashboard - Full Screen Mode Initializing...');
        console.log('Configuration:', CONFIG);

        initializeElements();
        validateConfiguration();
        setupFullScreenMode();
        embedSupersetDashboard();
    });

    function initializeElements() {
        loadingIndicator = document.getElementById('loading-indicator');
        errorMessage = document.getElementById('error-message');
        errorText = document.getElementById('error-text');
        dashboardContainer = document.getElementById('dashboard-container');
    }

    function validateConfiguration() {
        if (!CONFIG.dashboardId || CONFIG.dashboardId === 'contact-tts-group-for-uuid') {
            showError('Dashboard ID not configured. Please contact TTS Group for your dashboard UUID.');
            return false;
        }
        return true;
    }

    function setupFullScreenMode() {
        // Ensure proper full screen setup
        console.log('📐 Setting up full screen mode...');

        // Calculate exact height
        const headerHeight = document.querySelector('.header').offsetHeight;
        const availableHeight = window.innerHeight - headerHeight;

        console.log(`Header height: ${headerHeight}px, Available height: ${availableHeight}px`);

        // Set dashboard container to exact available height
        dashboardContainer.style.height = availableHeight + 'px';

        // Handle window resize for full screen
        window.addEventListener('resize', function() {
            const newHeaderHeight = document.querySelector('.header').offsetHeight;
            const newAvailableHeight = window.innerHeight - newHeaderHeight;
            dashboardContainer.style.height = newAvailableHeight + 'px';
            console.log(`📐 Resized - New height: ${newAvailableHeight}px`);
        });
    }

    // Main function to embed Superset dashboard
    async function embedSupersetDashboard() {
        if (!validateConfiguration()) {
            return;
        }

        try {
            retryCount++;
            showLoading();

            console.log(`🔄 Attempt ${retryCount}: Starting full screen dashboard embedding...`);

            // Step 1: Get guest token from Spring Boot backend
            const guestToken = await fetchGuestToken();

            if (!guestToken) {
                throw new Error('Guest token is missing in response');
            }

            console.log('🎫 Guest token retrieved successfully');

            // Step 2: Embed the dashboard using Superset SDK
            await embedDashboard(guestToken);

            console.log('✅ Full screen dashboard embedded successfully');
            hideLoading();
            retryCount = 0;

        } catch (error) {
            console.error('❌ Error embedding dashboard:', error);
            handleEmbeddingError(error);
        }
    }

    // Fetch guest token from Spring Boot backend
    async function fetchGuestToken() {
        try {
            console.log('📡 Requesting guest token from:', CONFIG.backendUrl);

            const response = await axios.post(CONFIG.backendUrl, {
                dashboardId: CONFIG.dashboardId
            }, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                timeout: 30000,
                withCredentials: true
            });

            console.log('📨 Backend response received:', response.status);

            if (!response.data || !response.data.token) {
                throw new Error('Invalid response from backend - token missing');
            }

            return response.data.token;

        } catch (error) {
            if (error.response) {
                const status = error.response.status;
                let message = 'Unknown backend error';

                if (error.response.data?.error) {
                    message = error.response.data.error;
                } else if (error.response.data?.message) {
                    message = error.response.data.message;
                }

                // Handle specific permission errors
                if (status === 403) {
                    message = 'Dashboard access denied (403). Contact TTS Group for proper permissions.';
                }

                throw new Error(`Backend error (${status}): ${message}`);
            } else if (error.request) {
                throw new Error('No response from backend server. Please check if the TTS backend service is running.');
            } else {
                throw new Error(`Request setup error: ${error.message}`);
            }
        }
    }

    // Embed dashboard using Superset SDK for full screen display
    async function embedDashboard(guestToken) {
        try {
            // Check if Superset SDK is available
            if (typeof supersetEmbeddedSdk === 'undefined') {
                throw new Error('Superset Embedded SDK not loaded. Please check the script inclusion.');
            }

            console.log('🎨 Embedding full screen dashboard with ID:', CONFIG.dashboardId);

            // Clear container
            dashboardContainer.innerHTML = '';

            // Remove trailing slash from URL
            const supersetDomain = CONFIG.supersetUrl.replace(/\/$/, '');

            // Embed with full screen configuration
            await supersetEmbeddedSdk.embedDashboard({
                id: CONFIG.dashboardId,
                supersetDomain: supersetDomain,
                mountPoint: dashboardContainer,
                fetchGuestToken: () => guestToken,
                dashboardUiConfig: {
                    ...CONFIG.dashboardUiConfig,
                    // ADDITIONAL FULL SIZE CONFIGURATION
                    hideTitle: true,
                    hideTab: true,
                    hideChartControls: false,
                    filters: {
                        expanded: false,
                        visible: true
                    }
                },
                debug: CONFIG.environment === 'development'
            });

            console.log('✅ Dashboard embedded, forcing full size...');

            // FORCE FULL SIZE AFTER EMBEDDING
            setTimeout(() => {
                forceFullSize();
            }, 1000);

            console.log('✅ Full screen dashboard embedding completed');

        } catch (error) {
            console.error('❌ Dashboard embedding error:', error);

            // Enhanced error messages
            if (error.message.includes('404')) {
                throw new Error(`Dashboard not found (404). Please verify dashboard ID: ${CONFIG.dashboardId}`);
            } else if (error.message.includes('403')) {
                throw new Error('Dashboard access denied (403). Contact TTS Group for proper permissions.');
            } else {
                throw new Error(`Dashboard embedding failed: ${error.message}`);
            }
        }
    }

    // FORCE DASHBOARD TO FULL SIZE
    function forceFullSize() {
        console.log('🔧 Forcing dashboard to full size...');

        // Find and resize iframe
        const iframe = dashboardContainer.querySelector('iframe');
        if (iframe) {
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.minWidth = '100%';
            iframe.style.minHeight = '100%';
            iframe.style.maxWidth = 'none';
            iframe.style.maxHeight = 'none';
            console.log('✅ Iframe resized to full size');
        }

        // Find and resize any superset containers
        const containers = dashboardContainer.querySelectorAll('[class*="dashboard"], [class*="superset"]');
        containers.forEach(container => {
            container.style.width = '100%';
            container.style.height = '100%';
            container.style.minWidth = '100%';
            container.style.maxWidth = 'none';
        });

        // Force window resize event to trigger Superset's responsive behavior
        window.dispatchEvent(new Event('resize'));

        console.log('✅ Dashboard forced to full size');
    }

    function handleEmbeddingError(error) {
        if (retryCount < MAX_RETRIES) {
            console.log(`🔄 Retrying in 3 seconds... (${retryCount}/${MAX_RETRIES})`);
            setTimeout(embedSupersetDashboard, 3000);
        } else {
            console.error('❌ Max retries reached');
            showError(error.message || 'Failed to load dashboard after multiple attempts');
        }
    }

    // UI state management functions
    function showLoading() {
        isLoading = true;
        currentError = null;
        loadingIndicator.style.display = 'block';
        errorMessage.style.display = 'none';
    }

    function hideLoading() {
        isLoading = false;
        loadingIndicator.style.display = 'none';
    }

    function showError(message) {
        isLoading = false;
        currentError = message;
        retryCount = 0;
        loadingIndicator.style.display = 'none';
        errorText.textContent = message;
        errorMessage.style.display = 'block';
    }

    // Enhanced window resize handler for full screen mode
    window.addEventListener('resize', function() {
        if (!isLoading && !currentError) {
            console.log('📐 Window resized - adjusting full screen layout');
            setupFullScreenMode();

            // Force dashboard to resize after window resize
            setTimeout(() => {
                forceFullSize();
            }, 300);
        }
    });

    // Prevent scroll on body when dashboard is loaded
    window.addEventListener('load', function() {
        document.body.style.overflow = 'hidden';
    });

    // Error handler for unhandled promise rejections
    window.addEventListener('unhandledrejection', function(event) {
        console.error('❌ Unhandled promise rejection:', event.reason);
        if (isLoading) {
            showError('An unexpected error occurred while loading the dashboard');
        }
    });

    // Optional: Refresh dashboard function
    function refreshDashboard() {
        console.log('🔄 Refreshing full screen dashboard...');
        retryCount = 0;
        embedSupersetDashboard();
    }

    // PERIODIC FULL SIZE CHECK
    function startFullSizeMonitor() {
        // Check every 5 seconds if dashboard is still full size
        setInterval(() => {
            if (!isLoading && !currentError) {
                const iframe = dashboardContainer.querySelector('iframe');
                if (iframe) {
                    const containerWidth = dashboardContainer.offsetWidth;
                    const iframeWidth = iframe.offsetWidth;

                    // If iframe is significantly smaller than container, force resize
                    if (iframeWidth < containerWidth * 0.95) {
                        console.log('📐 Dashboard size drift detected, forcing full size...');
                        forceFullSize();
                    }
                }
            }
        }, 5000);
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        // Ctrl+R for refresh
        if (event.ctrlKey && event.key === 'r') {
            event.preventDefault();
            refreshDashboard();
        }

        // F11 for browser full screen (optional)
        if (event.key === 'F11') {
            console.log('🖥️ Browser full screen mode toggled');
        }
    });

    // Optional: Full screen API support
    function toggleBrowserFullScreen() {
        if (document.fullscreenElement) {
            document.exitFullscreen();
        } else {
            document.documentElement.requestFullscreen();
        }
    }

<%--    // Debug information--%>
<%--    console.log('📊 Full Screen Dashboard Configuration:');--%>
<%--    console.log('- Dashboard ID:', CONFIG.dashboardId);--%>
<%--    console.log('- Superset URL:', CONFIG.supersetUrl);--%>
<%--    console.log('- Hide Title:', CONFIG.dashboardUiConfig.hideTitle);--%>
<%--    console.log('- Hide Tabs:', CONFIG.dashboardUiConfig.hideTab);--%>
<%--    console.log('- Environment:', CONFIG.environment);--%>

</script>
</body>
</html>