<%--
  Created by IntelliJ IDEA.
  User: sandeep
  Date: 6/27/2025
  Time: 10:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TTS Dashboard Test</title>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            max-width: 800px;
            margin: 0 auto;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        .status {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #28a745;
        }

        .info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #6c757d;
        }

        .info table {
            width: 100%;
            border-collapse: collapse;
        }

        .info table td {
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .info table td:first-child {
            font-weight: 600;
            width: 150px;
            color: #495057;
        }

        .steps {
            background: #e7f3ff;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #007bff;
        }

        .steps ol {
            margin: 10px 0;
            padding-left: 20px;
        }

        .steps li {
            margin: 8px 0;
            line-height: 1.5;
        }

        .btn-group {
            text-align: center;
            margin: 30px 0;
        }

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 0 10px;
            font-size: 14px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        .system-info {
            background: #fff3cd;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #ffc107;
        }

        code {
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            color: #e83e8c;
        }

        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🚀 TTS Dashboard</h1>

    <div class="status">
        <strong>✅ Success!</strong> Your TTS Dashboard application is running correctly.
    </div>

    <div class="info">
        <h3>System Information</h3>
        <table>
            <tr>
                <td>Current Time:</td>
                <td><%= new java.util.Date() %></td>
            </tr>
            <tr>
                <td>Server Port:</td>
                <td>8088</td>
            </tr>
            <tr>
                <td>Context Path:</td>
                <td><%= request.getContextPath() %></td>
            </tr>
            <tr>
                <td>Session ID:</td>
                <td><%= session.getId() %></td>
            </tr>
            <tr>
                <td>Server Info:</td>
                <td><%= application.getServerInfo() %></td>
            </tr>
            <tr>
                <td>Java Version:</td>
                <td><%= System.getProperty("java.version") %></td>
            </tr>
            <tr>
                <td>Operating System:</td>
                <td><%= System.getProperty("os.name") %> <%= System.getProperty("os.version") %></td>
            </tr>
        </table>
    </div>

    <div class="steps">
        <h3>Next Steps:</h3>
        <ol>
            <li>Update your Superset credentials in <code>application.properties</code></li>
            <li>Contact TTS Group for your dashboard UUID</li>
            <li>Test the dashboard functionality using the buttons below</li>
            <li>Configure your dashboard settings</li>
            <li>Deploy to your production environment</li>
        </ol>
    </div>

    <div class="system-info">
        <h3>⚙️ Configuration Required</h3>
        <p>Before you can use the dashboard, make sure to configure the following properties:</p>
        <ul>
            <li><code>superset.username</code> - Your biDarshan username</li>
            <li><code>superset.password</code> - Your biDarshan password</li>
            <li><code>superset.email</code> - Your email address</li>
            <li><code>superset.default.dashboard.id</code> - Dashboard UUID from TTS Group</li>
        </ul>
    </div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn">📊 Go to Dashboard</a>
        <a href="${pageContext.request.contextPath}/dashboard/config" class="btn">⚙️ Configuration</a>
        <a href="${pageContext.request.contextPath}/api/superset/health" class="btn" target="_blank">🏥 Health Check</a>
    </div>

    <div class="footer">
        <p>TTS Dashboard v1.0.0 | Powered by Spring Boot & biDarshan</p>
        <p>For support, contact the TTS Group</p>
    </div>
</div>

<script>
    // Add some basic interactivity
    document.addEventListener('DOMContentLoaded', function() {
        console.log('TTS Dashboard Test Page Loaded');
        console.log('Server Info:', '<%= application.getServerInfo() %>');
        console.log('Session ID:', '<%= session.getId() %>');
    });
</script>
</body>
</html>