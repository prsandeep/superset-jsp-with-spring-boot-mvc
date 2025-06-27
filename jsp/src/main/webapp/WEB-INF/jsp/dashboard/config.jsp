<%--
  Created by IntelliJ IDEA.
  User: sandeep
  Date: 6/26/2025
  Time: 8:28 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TTS Dashboard Configuration</title>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .content {
            padding: 30px;
        }

        .section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
        }

        .section h3 {
            margin-top: 0;
            color: #333;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .dashboard-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            transition: box-shadow 0.2s;
        }

        .dashboard-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .dashboard-card h4 {
            margin: 0 0 10px 0;
            color: #667eea;
        }

        .dashboard-card p {
            margin: 5px 0;
            color: #666;
            font-size: 14px;
        }

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px 0;
            font-size: 14px;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .status-up {
            background-color: #4caf50;
        }

        .status-down {
            background-color: #f44336;
        }

        .config-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .config-table th,
        .config-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .config-table th {
            background-color: #f5f5f5;
            font-weight: 600;
        }

        .back-btn {
            background: #6c757d;
            margin-right: 10px;
        }

        .back-btn:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>TTS Dashboard Configuration</h1>
        <p>Dashboard Management and Configuration</p>
    </div>

    <div class="content">
        <!-- Navigation -->
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn back-btn">← Back to Dashboard</a>
            <a href="${pageContext.request.contextPath}/api/superset/health" class="btn" target="_blank">🏥 Health Check</a>
        </div>

        <!-- Current Configuration -->
        <div class="section">
            <h3>Current Configuration</h3>
            <table class="config-table">
                <tr>
                    <th>Setting</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Superset URL</td>
                    <td>${supersetUrl}</td>
                </tr>
                <tr>
                    <td>Environment</td>
                    <td>${environment}</td>
                </tr>
                <tr>
                    <td>Default Dashboard ID</td>
                    <td>${defaultDashboardId != null ? defaultDashboardId : 'Not configured'}</td>
                </tr>
                <tr>
                    <td>Service Status</td>
                    <td>
                        <span class="status-indicator status-up"></span>
                        <span id="service-status">Checking...</span>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Available Dashboards -->
        <div class="section">
            <h3>Available Dashboards</h3>
            <div class="dashboard-grid">
                <c:forEach var="dashboard" items="${availableDashboards}">
                    <div class="dashboard-card">
                        <h4>${dashboard.name}</h4>
                        <p><strong>ID:</strong> ${dashboard.id}</p>
                        <p><strong>Category:</strong> ${dashboard.category}</p>
                        <p><strong>Description:</strong> ${dashboard.description}</p>
                        <p><strong>Access:</strong> ${dashboard.public ? 'Public' : 'Private'}</p>
                        <a href="${pageContext.request.contextPath}/dashboard/${dashboard.id}" class="btn">View Dashboard</a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="section">
            <h3>Quick Actions</h3>
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <button class="btn" onclick="checkHealth()">🔄 Refresh Health Status</button>
                <button class="btn" onclick="testConnection()">🔗 Test Superset Connection</button>
                <a href="${pageContext.request.contextPath}/dashboard/test" class="btn">🧪 Test Page</a>
            </div>
        </div>

        <!-- Setup Instructions -->
        <div class="section">
            <h3>Setup Instructions</h3>
            <ol>
                <li>Contact TTS Group to get your dashboard UUID</li>
                <li>Update <code>superset.default.dashboard.id</code> in application.properties</li>
                <li>Verify your Superset credentials are correct</li>
                <li>Test the dashboard embedding functionality</li>
            </ol>

            <h4>Required Configuration Properties:</h4>
            <pre style="background: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto;">
superset.url=https://bidarshan-dev.dcservices.in
superset.username=your_superset_username
superset.password=your_superset_password
superset.first_name=Your
superset.last_name=Name
superset.email=your.email@company.com
superset.default.dashboard.id=your-dashboard-uuid</pre>
        </div>
    </div>
</div>

<script>
    // Check service health on page load
    document.addEventListener('DOMContentLoaded', function() {
        checkHealth();
    });

    async function checkHealth() {
        const statusElement = document.getElementById('service-status');
        const indicator = document.querySelector('.status-indicator');

        statusElement.textContent = 'Checking...';
        indicator.className = 'status-indicator';

        try {
            const response = await fetch('${pageContext.request.contextPath}/api/superset/health');
            const health = await response.json();

            if (health.status === 'UP') {
                statusElement.textContent = 'Service is running';
                indicator.className = 'status-indicator status-up';
            } else {
                statusElement.textContent = 'Service issues detected';
                indicator.className = 'status-indicator status-down';
            }
        } catch (error) {
            statusElement.textContent = 'Health check failed';
            indicator.className = 'status-indicator status-down';
            console.error('Health check error:', error);
        }
    }

    async function testConnection() {
        const originalText = event.target.textContent;
        event.target.textContent = '🔄 Testing...';
        event.target.disabled = true;

        try {
            const response = await fetch('${pageContext.request.contextPath}/api/superset/health');
            const result = await response.json();

            if (result.status === 'UP') {
                alert('✅ Connection successful!\n\nSuperset is reachable and responding.');
            } else {
                alert('⚠️ Connection issues detected.\n\nDetails: ' + result.message);
            }
        } catch (error) {
            alert('❌ Connection failed!\n\nError: ' + error.message);
        } finally {
            event.target.textContent = originalText;
            event.target.disabled = false;
        }
    }
</script>
</body>
</html>
