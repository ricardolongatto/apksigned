# APKsigned

Script para assinar APKs de forma rápida, utilizando `keytool` e `apksigner`.

## Compatibilidade

- Linux
- macOS

## Requisitos

- `keytool` no PATH
- `apksigner` no PATH

## Funcionalidades

- Gera automaticamente uma chave (`pentest.jks`) se não existir
- Usa alias `pentest` e senha padrão `desec123`
- Assina APKs com `apksigner`
- Define nome automático de saída (`*_signed.apk`) se não especificado

## Uso

```bash
./APKsigned.sh -f arquivo.apk
./APKsigned.sh -f arquivo.apk -o app_assinado.apk
```

## Gerando a chave (feito automaticamente se não existir)

```bash
keytool -genkey -v -keystore pentest.jks -alias pentest -keyalg RSA -keysize 2048 -validity 10000
```

## Assinatura do APK

```bash
apksigner sign --ks pentest.jks --ks-key-alias pentest --out app_signed.apk app.apk
```

---

**Desenvolvido para fins educacionais — Pentest Mobile | Desec**
