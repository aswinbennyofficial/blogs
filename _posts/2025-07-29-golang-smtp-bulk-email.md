---
title: "Building a Bulk Email Sender in Go with HTML Support"
date: 2025-07-29
categories: [compile, architecture]
tags: [golang, smtp, email, backend, tutorial]
image: /assets/img/posts/golang-smtp-bulk-email-1.png
redirect_from:
  - /bulk-email-program-golang
  - /bulk-email-program-golang/
description: >-
  Build a bulk email sender in Go with SMTP, HTML support, and custom reply-to. Complete tutorial with code examples and environment setup.

# Additional SEO Tags
seo:
  type: Article
  date_modified: 2025-07-29
  links: ["https://blog.aswinbenny.in/posts/golang-smtp-bulk-email/"]

# Tutorial-specific keywords
keywords: ["golang tutorial", "go email sender", "SMTP golang", "bulk email", "HTML email", "go programming", "email automation", "golang SMTP"]

# Social sharing
og_image: /assets/img/posts/golang-smtp-bulk-email-1.png
og_description: "Step-by-step tutorial: Build a bulk email sender in Go with SMTP and HTML support"


# Content metadata
breadcrumbs: true
toc: true
---



In this tutorial, we'll build a Go program that sends bulk emails through SMTP with custom reply-to addresses and rich HTML content. We'll use Go's built-in `net/smtp` package alongside `github.com/joho/godotenv` for managing environment variables securely.


You can find the complete source code in my [GitHub repository](https://github.com/aswinbennyofficial/Golang/tree/main/project/11_Golang_SMTP_mailSend).

---

## 🚀 Prerequisites

Before we begin, make sure you have:

- Go installed on your system
- Access to an SMTP server (Gmail, SendGrid, etc.)
- Basic understanding of Go syntax

---

## 📦 Setting Up Dependencies

First, let's install the required package for environment variable management:

```
go get github.com/joho/godotenv
```

---

## 🔧 Configuration Setup

Create a `.env` file in your project root to store sensitive SMTP credentials:

```
# Rename this file to .env 

# SMTP credentials
SMTP_USERNAME=""
SMTP_PASSWORD=""

# SMTP server information
SMTP_HOST=""
SMTP_PORT=""

# Sender's email address
FROM_EMAIL=""
```

**Important:** Never commit your `.env` file to version control. Add it to your `.gitignore` file.

---

## 💻 Implementation

Now let's create our main Go file with the bulk email functionality:

```
package main

import (
    "fmt"
    "github.com/joho/godotenv"
    "log"
    "os"
    "net/smtp"
)

func main() {
    // Loading environment variables
    err := godotenv.Load(".env")
    if err != nil {
        log.Fatalf("Error loading environment variables file")
    }

    // SMTP server credentials from .env file
    SMTP_USERNAME := os.Getenv("SMTP_USERNAME")
    SMTP_PASSWORD := os.Getenv("SMTP_PASSWORD")
    SMTP_HOST := os.Getenv("SMTP_HOST")
    FROM_EMAIL := os.Getenv("FROM_EMAIL")
    SMTP_PORT := os.Getenv("SMTP_PORT")

    log.Println("SMTP credentials initialized for:", SMTP_USERNAME)

    // Setup authentication
    auth := smtp.PlainAuth("", SMTP_USERNAME, SMTP_PASSWORD, SMTP_HOST)

    // List of recipient emails
    toList := []string{"recipient1@gmail.com"}
    // For multiple recipients:
    // toList := []string{"email1@gmail.com", "email2@gmail.com", "email3@gmail.com"}

    // Email content
    subject := "Test Golang Program"
    body := "Hello, this is an HTML-rich email template!"
    
    // Custom reply-to email (optional)
    reply_to := ""
    if reply_to == "" {
        reply_to = FROM_EMAIL
    }

    // Construct email message with HTML support
    var msg []byte
    msg = []byte(
        "From: " + FROM_EMAIL + "\r\n" +
        "Reply-To: " + reply_to + "\r\n" +
        "Subject: " + subject + "\r\n" +
        "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\r\n" +
        "\r\n" +
        body + "\r\n")

    // Send the email
    err = smtp.SendMail(SMTP_HOST+":"+SMTP_PORT, auth, FROM_EMAIL, toList, msg)

    // Handle any errors
    if err != nil {
        log.Println("Failed to send email:", err)
        os.Exit(1)
    }

    fmt.Println("✅ Successfully sent emails to all recipients!")
}
```

---

## 🏃‍♂️ Running the Program

Execute your program with:

```
go run .
```

If everything is configured correctly, you should see a success message indicating that emails were sent to all recipients.

---

## 🎨 Customization Options

### For Plain Text Emails

If you prefer plain text over HTML, replace the message construction with:

```
msg = []byte(
    "Reply-To: " + reply_to + "\r\n" +
    "Subject: " + subject + "\r\n" +
    "\r\n" +
    body + "\r\n")
```

### Adding More Recipients

Simply expand the `toList` slice:

```
toList := []string{
    "user1@example.com",
    "user2@example.com",
    "user3@example.com",
}
```

---

## 🛡️ Best Practices

- **Rate Limiting:** Most SMTP providers have sending limits. Consider adding delays between emails for large batches.
- **Error Handling:** Implement retry logic for failed sends.
- **Security:** Never hardcode credentials. Always use environment variables.
- **Validation:** Validate email addresses before sending.

---

## 🎯 Conclusion

You've successfully built a Go program that can send bulk emails with HTML content and custom reply-to addresses. This foundation can be extended to include templates, better error handling, and more sophisticated email features.

The combination of Go's simplicity and the power of SMTP makes email automation straightforward and efficient. Feel free to customize this code for your specific use cases—whether it's newsletters, notifications, or marketing campaigns.

Happy coding! 🚀
