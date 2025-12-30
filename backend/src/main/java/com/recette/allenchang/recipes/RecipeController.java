package com.recette.allenchang.backend.controllers;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.recette.allenchang.backend.services.S3Service;

@RestController
public class RecipeController {
    private final S3Service S3Service;

    public RecipeController(S3Service S3Service) {
        this.S3Service = S3Service;
    }

    /** REST endpoint to handle uploading photo to amazon S3 */
    @PostMapping("upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String publicUrl = S3Service.optimizeAndUploadImage(file);
            return ResponseEntity.ok(publicUrl);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to upload image: " + e.getMessage());
        }
    }

    /** REST endpoint to handle delting photo from amazon S3 */
    @DeleteMapping("delete-image")
    public ResponseEntity<String> deleteFile(@RequestParam("url") String fileUrl) {
        try {
            S3Service.deleteImage(fileUrl);
            return ResponseEntity.ok("Deleted image: " + fileUrl);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete image: " + e.getMessage());
        }
    }

}
