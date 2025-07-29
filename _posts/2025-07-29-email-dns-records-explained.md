---
title: "Email DNS Records Explained"
date: 2025-07-29
categories: [compile, architecture]
tags: [backend, dns, email]
image: /assets/img/posts/email-dns-records-explained-1.png
description: >-
  Complete guide to email DNS records including SPF, DKIM, DMARC, and MX records. 
  Learn how to prevent email spoofing, enhance domain security, and maintain customer trust 
  with proper email authentication protocols. 
---



This article provides an overview of critical email authentication methods—SPF, DKIM, DMARC—and MX records. These technologies work together to enhance your domain’s security, prevent email spoofing, and maintain your business’s online reputation and customer trust.

> For brief explanations, scroll to the **Inshort** section at the bottom.

---

## 🛡️ SPF (Sender Policy Framework)

**What is SPF?**  
SPF is an email authentication method designed to prevent spoofing by specifying which IP addresses are authorized to send emails on behalf of your domain.

**How does it work?**  
When an email is received, the recipient’s mail server checks the SPF record in the sender’s DNS to verify if the email came from an authorized IP address.

**Use case example:**  
If you own `mycompany.com` and want only your official mail servers to send emails from your domain, you set up an SPF DNS record listing those servers’ IP addresses.

**Common issues:**  
Misconfigured or outdated SPF records can cause legitimate emails to be rejected or marked as spam.

---

## 🔑 DKIM (DomainKeys Identified Mail)

**What is DKIM?**  
DKIM adds a digital signature to outgoing emails using a private key. The recipient verifies this signature with the public key published in your DNS records.

**How does it work?**  
The sender’s mail server signs the email header with the private key. The recipient uses the public key from DNS to confirm the email’s authenticity.

**Use case example:**  
For `mycompany.com`, DKIM helps prove that messages claiming to be from your domain are indeed sent by your authorized servers.

**Common issues:**  
Poor key management—such as compromised or lost private keys—can lead to security risks or spoofing vulnerabilities.

---

## 🛡️ DMARC (Domain-based Message Authentication, Reporting, and Conformance)

**What is DMARC?**  
DMARC builds on SPF and DKIM by allowing domain owners to specify policies on how to handle emails failing authentication checks. It also provides reports on failures.

**How does it work?**  
You define policies like quarantine or reject for emails that fail SPF or DKIM. Email providers use these rules to handle suspicious emails.

**Use case example:**  
Domain owners at `mycompany.com` can instruct providers to quarantine or reject malicious emails impersonating their domain, reducing phishing attacks.

**Common issues:**  
Configuring DMARC requires careful monitoring of failure reports. Strict policies may accidentally block legitimate emails if not set up properly.

---

## 📬 MX Records (Mail Exchange Records)

**What are MX records?**  
MX records are DNS entries that specify the mail servers responsible for receiving emails on behalf of your domain.

**How does it work?**  
When someone sends an email to `user@mycompany.com`, their mail server queries DNS to find your MX records and delivers the email accordingly.

**Use case example:**  
To handle incoming mail for `mycompany.com`, you configure MX records pointing to your mail servers, such as `mail.mycompany.com`.

**Common issues:**  
Misconfigured MX records or server downtime can cause email delivery failures or delays.

---

## 🔗 Putting It All Together: A Real-World Example

Imagine you run an online store at `aswinbenny.in`. To secure your email communications:

1. Set up SPF records authorizing your mail servers to send emails for `aswinbenny.in`.
2. Implement DKIM to digitally sign outgoing emails and assure recipients they are authentic.
3. Configure DMARC to specify how to handle emails failing SPF/DKIM checks (e.g., reject or quarantine).
4. Ensure your MX records correctly route incoming emails to your mail servers.

By doing so, you reduce phishing risks, maintain your domain’s reputation, and build customer trust.

---

## 📋 Inshort

### Email Spoofing

- Attackers can forge email headers to appear as trusted senders.
- SPF, DKIM, and DMARC are essential defenses to prevent spoofing.
- DMARC provides reporting on rejected or quarantined emails.

### MX Record Basics

- Type: **MX**
- Purpose: Directs incoming emails for your domain to designated mail servers.
- Example settings:
  - Name: `@` (root domain) or a subdomain
  - Value: hostname of mail server (e.g., `mail.mycompany.com`)

### SPF Record Basics

- Type: **TXT**
- Specifies authorized sending IPs for your domain.
- Example value:  
  `v=spf1 include:spf.example.com ~all`

### DKIM Record Basics

- Type: **TXT**
- Publishes your public DKIM key.
- Example name: `selector1._domainkey.mycompany.com`
- Contains the public key used to verify email signatures.

### DMARC Record Basics

- Type: **TXT**
- Defines policy for handling emails failing SPF/DKIM.
- Example name: `_dmarc.mycompany.com`
- Example value:  
  `v=DMARC1; p=reject; rua=mailto:report@yourdomain.com`

---

By properly setting up SPF, DKIM, DMARC, and MX records, you can significantly improve your email security posture and safeguard your domain’s communications.
