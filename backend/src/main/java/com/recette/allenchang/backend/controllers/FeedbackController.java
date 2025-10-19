package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.services.EmailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class FeedbackController {
    private final EmailService emailService;

    public FeedbackController(EmailService emailService) {
        this.emailService = emailService;
    }

    @PostMapping("/feedback")
    public ResponseEntity<String> sendFeedback(@RequestParam("message") String message) {
        System.out.println("Sending feedback email...");

        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Message cannot be empty.");
        }

        String subject = "Recette Feedback";
        String html = """
                    <div style="font-family: -apple-system, Helvetica, Arial, sans-serif; line-height:1.5;">
                      <h2 style="margin:0 0 12px 0;">New Feedback from Recette App</h2>
                      <p>%s</p>
                    </div>
                """.formatted(escapeHtml(message.trim()));

        try {
            emailService.sendEmail("recetteapp.ios@gmail.com", subject, html);
            return ResponseEntity.ok("Feedback sent successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to send feedback.");
        }
    }

    private static String escapeHtml(String s) {
        return s.replace("&", "&amp;").replace("<", "&lt;");
    }

}
