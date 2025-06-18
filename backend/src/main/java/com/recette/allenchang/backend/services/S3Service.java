package com.recette.allenchang.backend.services;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import org.imgscalr.Scalr;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.util.UUID;

/**
 * Provides S3 helper functions such as uploading/deleting images to S3 and
 * optimizing/converting images
 */

@Service
public class S3Service {

    private final AmazonS3 amazonS3;
    private final String bucketName = "recette-recipe-images-bucket";

    public S3Service(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    /**
     * Public entrypoint to optimize and upload a WebP recipe image. The function
     * uses the two helper functions optimizeImage and uploadImage to upload an
     * optimized and resized version of the image with the webp extension to S3.
     * 
     * @param file image passed in through the request
     * @return
     * @throws IOException
     */
    public String optimizeAndUploadImage(MultipartFile file) throws IOException {
        byte[] optimizedWebP = optimizeImage(file);
        String key = UUID.randomUUID() + ".jpg";
        return uploadImage(optimizedWebP, key, "image/jpg");
    }

    /**
     * Optimizes the image by resizing it and then converts it to a webp. Uses scalr
     * to resize the image and a byte array output stream to create an in memory
     * buffer to hold binary image data. This allows us to keep everything in memory
     * for performance and cleanliness.
     * 
     * TODO: implement limit upload sizes
     * 
     * @param file user image to be optimized
     * @return raw binary of webP image
     */
    public byte[] optimizeImage(MultipartFile file) throws IOException {
        BufferedImage originalImage = ImageIO.read(file.getInputStream());
        int targetWidth = 1080;

        /**
         * Scalr docs: https://github.com/rkalla/imgscalr?tab=readme-ov-file
         * Consider switching to a balanced method, check scalr docs.
         */
        BufferedImage resizedImage = originalImage.getWidth() > targetWidth
                ? Scalr.resize(originalImage, Scalr.Method.QUALITY, Scalr.Mode.FIT_TO_WIDTH, targetWidth)
                : originalImage;

        /**
         * Encodes the image and compresses it into the WebP binary format.
         * 
         * TODO: Convert back to webp, currently jpg for testing
         */
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ImageIO.write(resizedImage, "jpg", outputStream);

        /**
         * Converts the in-memory stream into a byte[], which is just a raw binary
         * representation of the WebP image and returns it.
         */
        return outputStream.toByteArray();
    }

    /**
     * Uploads raw image bytes to S3 under the given key and content type.
     * 
     * @param imageBytes  byte array recieved from optimize function
     * @param key         file path inside the S3 bucket
     * @param contentType image extension
     * @return publicUrl to be saved in DB
     */
    public String uploadImage(byte[] imageBytes, String key, String contentType) {
        ByteArrayInputStream inputStream = new ByteArrayInputStream(imageBytes);

        /** Attach meta data to the upload request */
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(imageBytes.length);
        metadata.setContentType(contentType);

        /**
         * Uploads the image to S3, gets the public URL, and return it so we
         * can save it to the DB or use it in the frontend
         */
        amazonS3.putObject(new PutObjectRequest(bucketName, key, inputStream, metadata));
        URL publicUrl = amazonS3.getUrl(bucketName, key);
        return publicUrl.toString();
    }

    /** Deletes an image from S3 */
    public void deleteImage(String imageUrl) {
        /* Key needs to be just the S3 object not the whole url */
        String key = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
        amazonS3.deleteObject(bucketName, key);
    }

}
