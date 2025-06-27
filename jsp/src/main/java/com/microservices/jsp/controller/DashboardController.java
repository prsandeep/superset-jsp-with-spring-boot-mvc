package com.microservices.jsp.controller;

import com.microservices.jsp.config.SupersetConfig;
import com.microservices.jsp.service.SupersetService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
@Slf4j
public class DashboardController {

    private final SupersetService supersetService;
    private final SupersetConfig supersetConfig;

    @Value("${app.environment:development}")
    private String environment;

    /**
     * Main dashboard page
     */
    @GetMapping
    public String dashboard(Model model) {
        String defaultDashboardId = supersetConfig.getDefaultDashboardId();
        if (defaultDashboardId == null || defaultDashboardId.isEmpty()) {
            model.addAttribute("error", "Default dashboard ID not configured. Please contact TTS Group.");
            return "dashboard/error";
        }
        return dashboard(defaultDashboardId, model);
    }

    /**
     * Dashboard page with specific dashboard ID
     */
    @GetMapping("/{dashboardId}")
    public String dashboard(@PathVariable String dashboardId, Model model) {
        log.info("Loading dashboard: {} for user: {}", dashboardId, getCurrentUsername());

        // Add configuration to JSP model
        model.addAttribute("dashboardId", dashboardId);
        model.addAttribute("supersetUrl", supersetConfig.getUrl());
        model.addAttribute("environment", environment);

        // UI configuration
        model.addAttribute("hideTitle", true);
        model.addAttribute("hideChartControls", false);
        model.addAttribute("hideTab", false);

        // Add user context
        model.addAttribute("username", getCurrentUsername());
        model.addAttribute("timestamp", System.currentTimeMillis());

        return "dashboard/superset-dashboard";
    }

    /**
     * Dashboard configuration page
     */
    @GetMapping("/config")
    public String dashboardConfig(Model model) {
        model.addAttribute("availableDashboards", supersetService.getAvailableDashboards());
        model.addAttribute("supersetUrl", supersetConfig.getUrl());
        model.addAttribute("environment", environment);
        model.addAttribute("defaultDashboardId", supersetConfig.getDefaultDashboardId());
        return "dashboard/config";
    }

    /**
     * Error page
     */
    @GetMapping("/error")
    public String error() {
        return "dashboard/error";
    }

    private String getCurrentUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return (auth != null && auth.isAuthenticated()) ? auth.getName() : "anonymous";
    }
}