# Generate new gpg key for each workshop

## Steps

We will use the template created

- `export GPG_TTY=$(tty)`
- `gpg --batch --gen-key key-template-academy-users`
- `gpg --output public-key-academy-users.gpg --export dockerkubernetesparticipant@dataminded.be`
  - when prompted for passphrase, use one you remember

Decrypt the output password

```bash
enc_pass_with_quotes=$(terraform output password)
enc_pass_wo_quotes=${enc_pass_with_quotes:1:-1}
echo $enc_pass_wo_quotes | base64 --decode | gpg --decrypt
```