package com.microservices.jsp.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardInfo {
    private String id;
    private String name;
    private String description;
    private String category;
    private boolean isPublic;
    private String thumbnailUrl;
}