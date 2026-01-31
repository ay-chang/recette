package com.recette.allenchang.backend.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.resend.*;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;

@Service
public class EmailService {
    private final Resend resend;

    public EmailService(@Value("${resend.api-key}") String apiKey) {
        this.resend = new Resend(apiKey);
    }

    /** Send an email to user, can use for different reasons */
    public void sendEmail(String recipientEmail, String subject, String emailContent) {
        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("Recette <noreply@updates.recetteapp.com>")
                .to(recipientEmail)
                .subject(subject)
                .html(emailContent)
                .build();

        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println(data.getId());
        } catch (ResendException e) {
            e.printStackTrace();
        }
    }

}
