<%--
  Created by IntelliJ IDEA.
  User: sandeep
  Date: 6/27/2025
  Time: 10:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TTS Dashboard - Error</title>

  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 40px;
      background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
      min-height: 100vh;
    }

    .container {
      background: white;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      max-width: 600px;
      margin: 0 auto;
      text-align: center;
    }

    .error-icon {
      font-size: 64px;
      margin-bottom: 20px;
    }

    h1 {
      color: #d32f2f;
      margin-bottom: 20px;
    }

    .error-message {
      background: #ffebee;
      color: #c62828;
      padding: 20px;
      border-radius: 8px;
      margin: 20px 0;
      border-left: 4px solid #d32f2f;
    }

    .suggestions {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      margin: 20px 0;
      text-align: left;
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
      margin: 10px;
      font-size: 14px;
      transition: transform 0.2s;
    }

    .btn:hover {
      transform: translateY(-2px);
      color: white;
      text-decoration: none;
    }

    .btn-secondary {
      background: #6c757d;
    }

    .btn-secondary:hover {
      background: #5a6268;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="error-icon">⚠️</div>
  <h1>Dashboard Error</h1>

  <div class="error-message">
    <strong>Error:</strong> ${error != null ? error : 'An error occurred while loading the dashboard.'}
  </div>

  <div class="suggestions">
    <h3>Possible Solutions:</h3>
    <ul>
      <li>Verify your Superset credentials in application.properties</li>
      <li>Ensure the dashboard UUID is correctly configured</li>
      <li>Check if the biDarshan service is accessible</li>
      <li>Contact TTS Group for dashboard configuration assistance</li>
    </ul>
  </div>

  <div>
    <a href="${pageContext.request.contextPath}/dashboard/test" class="btn btn-secondary">🧪 Test Page</a>
    <a href="${pageContext.request.contextPath}/dashboard/config" class="btn">⚙️ Configuration</a>
    <a href="${pageContext.request.contextPath}/api/superset/health" class="btn" target="_blank">🏥 Health Check</a>
  </div>
</div>
</body>
</html>