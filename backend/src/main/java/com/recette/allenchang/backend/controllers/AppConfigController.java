package com.recette.allenchang.backend.controllers;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class AppConfigController {

    @Value("${app.version.minSupported}")
    private String minSupportedVersion;

    @Value("${app.version.latest:${app.version.minSupported}}")
    private String latestVersion;

    @Value("${app.version.message:}")
    private String message;

    @GetMapping("app-config")
    public Map<String, String> getAppConfig() {
        return Map.of(
                "minSupportedVersion", minSupportedVersion,
                "latestVersion", latestVersion,
                "message", message == null ? "" : message);
    }
}
