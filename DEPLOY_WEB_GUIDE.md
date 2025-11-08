# 🌐 Guia de Deploy - ChoppFlow Web para Clientes

## 📋 Visão Geral

Este guia mostra como publicar a versão web do ChoppFlow para que seus clientes possam acessar pelo navegador e ver os chopps disponíveis em tempo real.

---

## 🚀 Opções de Deploy (Recomendações)

### **Opção 1: Firebase Hosting** ⭐ **RECOMENDADO**
- ✅ **Gratuito** até 10 GB/mês
- ✅ **Integração perfeita** com Firestore (já usa Firebase)
- ✅ **HTTPS automático**
- ✅ **CDN global** (super rápido)
- ✅ **Domínio grátis** (seu-app.web.app)
- ⏱️ Setup: 10-15 minutos

### **Opção 2: Vercel** 
- ✅ **Gratuito** para projetos pessoais
- ✅ **Deploy automático** via GitHub
- ✅ **HTTPS automático**
- ✅ **Muito rápido**
- ⏱️ Setup: 5-10 minutos

### **Opção 3: GitHub Pages**
- ✅ **Totalmente gratuito**
- ✅ **Simples de usar**
- ⚠️ Requer configuração extra para SPA
- ⏱️ Setup: 15-20 minutos

---

## 🔥 Opção 1: Firebase Hosting (RECOMENDADO)

### **Por que Firebase Hosting?**
- Você já usa Firebase Firestore
- Mesma conta, mesmo console
- Configuração simples
- Deploy com um comando

### **Passo a Passo:**

#### **1. Instalar Firebase CLI**
```bash
# Instalar Firebase Tools globalmente
npm install -g firebase-tools

# Verificar instalação
firebase --version
```

#### **2. Login no Firebase**
```bash
# Fazer login na sua conta Google/Firebase
firebase login
```

#### **3. Inicializar Firebase Hosting no Projeto**
```bash
# Na pasta do projeto
cd /home/jeancarloscc/Documents/projects/choppflow

# Inicializar Firebase
firebase init hosting
```

**Durante a inicialização, responda:**
- **"Which Firebase project?"** → Selecione seu projeto ChoppFlow
- **"What directory?"** → Digite: `build/web`
- **"Configure as single-page app?"** → `Yes`
- **"Overwrite index.html?"** → `No`
- **"Set up automatic builds with GitHub?"** → `No` (por enquanto)

#### **4. Build da Aplicação Web**
```bash
# Gerar os arquivos web otimizados
flutter build web --release
```

Este comando cria a pasta `build/web` com todos os arquivos prontos para deploy.

#### **5. Deploy para Firebase Hosting**
```bash
# Fazer deploy
firebase deploy --only hosting
```

#### **6. Acessar o Site**
Após o deploy, você verá algo como:
```
✔  Deploy complete!

Hosting URL: https://seu-projeto.web.app
```

**Pronto! Seus clientes podem acessar:** `https://seu-projeto.web.app`

---

## 🎯 Opção 2: Vercel (Alternativa Rápida)

### **Passo a Passo:**

#### **1. Criar Conta na Vercel**
- Acesse: https://vercel.com
- Crie conta com GitHub, GitLab ou email

#### **2. Instalar Vercel CLI**
```bash
npm install -g vercel
```

#### **3. Build da Aplicação**
```bash
cd /home/jeancarloscc/Documents/projects/choppflow
flutter build web --release
```

#### **4. Deploy**
```bash
cd build/web
vercel --prod
```

Siga as instruções no terminal e pronto!

---

## 📱 Opção 3: GitHub Pages

### **Passo a Passo:**

#### **1. Criar Repositório no GitHub**
```bash
cd /home/jeancarloscc/Documents/projects/choppflow
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/seu-usuario/choppflow.git
git push -u origin main
```

#### **2. Build Web**
```bash
flutter build web --release --base-href "/choppflow/"
```

#### **3. Criar Branch gh-pages**
```bash
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin https://github.com/seu-usuario/choppflow.git
git push -f origin gh-pages
```

#### **4. Configurar GitHub Pages**
1. Vá em: `Settings` → `Pages`
2. Source: `gh-pages` branch
3. Salvar

**URL:** `https://seu-usuario.github.io/choppflow/`

---

## 🎨 Personalizar Domínio (Opcional)

### **Firebase Hosting - Domínio Customizado**

Se você tiver um domínio próprio (ex: `chopps.com.br`):

```bash
# Adicionar domínio customizado
firebase hosting:channel:deploy production --domain chopps.com.br
```

Depois, configure os registros DNS conforme instruções do Firebase.

### **Vercel - Domínio Customizado**
1. Dashboard da Vercel
2. Settings → Domains
3. Adicionar domínio
4. Configurar DNS

---

## 🔧 Configurações Adicionais

### **1. Atualizar Firebase Hosting Config**

Crie/edite `firebase.json` na raiz do projeto:

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=3600"
          }
        ]
      }
    ]
  }
}
```

### **2. Otimizar Build para Web**

Edite `web/index.html` para melhorar SEO:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- SEO -->
  <title>ChoppFlow - Chopps Disponíveis</title>
  <meta name="description" content="Veja os chopps disponíveis em tempo real">
  <meta name="keywords" content="chopp, cerveja, bar, disponível">
  
  <!-- PWA -->
  <link rel="manifest" href="manifest.json">
  <link rel="icon" type="image/png" href="favicon.png"/>
  
  <!-- Open Graph (redes sociais) -->
  <meta property="og:title" content="ChoppFlow - Chopps Disponíveis">
  <meta property="og:description" content="Veja os chopps disponíveis em tempo real">
  <meta property="og:type" content="website">
</head>
<body>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

---

## 📱 Gerar QR Code para Clientes

### **Depois do Deploy:**

1. **Use um gerador de QR Code:**
   - https://www.qr-code-generator.com/
   - https://www.qrcode-monkey.com/

2. **Insira a URL do seu site:**
   - `https://seu-projeto.web.app`

3. **Baixe o QR Code**

4. **Imprima e coloque:**
   - No balcão do bar
   - Nas mesas
   - No cardápio
   - Nas redes sociais

**Exemplo de texto para acompanhar o QR Code:**
```
📱 CHOPPS DISPONÍVEIS
Escaneie o QR Code para ver
os chopps disponíveis agora!

Atualização em tempo real 🍺
```

---

## 🔄 Como Atualizar o Site

### **Firebase Hosting:**
```bash
# 1. Fazer mudanças no código
# 2. Rebuild
flutter build web --release

# 3. Deploy novamente
firebase deploy --only hosting
```

### **Vercel:**
```bash
# 1. Fazer mudanças
# 2. Rebuild
flutter build web --release

# 3. Deploy
cd build/web
vercel --prod
```

### **GitHub Pages:**
```bash
# 1. Fazer mudanças
# 2. Rebuild
flutter build web --release --base-href "/choppflow/"

# 3. Push para gh-pages
cd build/web
git add .
git commit -m "Update"
git push -f origin gh-pages
```

---

## 🧪 Testar Localmente Antes do Deploy

```bash
# Build
flutter build web --release

# Servir localmente
cd build/web
python3 -m http.server 8000

# Abrir no navegador
# http://localhost:8000
```

---

## 📊 Monitorar Acessos

### **Firebase Hosting Analytics:**
1. Firebase Console
2. Hosting → Dashboard
3. Veja estatísticas de acessos

### **Google Analytics (Opcional):**

Adicione ao `web/index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

---

## 🔒 Segurança - Regras do Firestore

### **Importante:** Configure as regras para permitir leitura pública:

No Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Clientes podem LER todos os chopps
    match /items/{itemId} {
      allow read: if true;
      // Apenas você (vendedor) pode ESCREVER
      // Opção 1: Qualquer um pode escrever (NÃO RECOMENDADO em produção)
      allow write: if true;
      
      // Opção 2: Proteger escrita com autenticação (RECOMENDADO)
      // allow write: if request.auth != null;
    }
    
    match /history/{historyId} {
      allow read: if true;
      allow write: if true;
    }
  }
}
```

**⚠️ IMPORTANTE:** 
- Clientes precisam **ler** os chopps → `allow read: if true;`
- Apenas você deve **editar** → Configure autenticação ou IP whitelist

---

## 💡 Dicas Práticas

### **1. Link Curto**
Use um encurtador de URL para facilitar:
- https://bit.ly
- https://tinyurl.com

Exemplo: `bit.ly/chopps-disponiveis`

### **2. Compartilhar nas Redes Sociais**
```
🍺 Chopps Disponíveis Agora!

Veja em tempo real os chopps disponíveis:
https://seu-projeto.web.app

#chopp #bar #cervejaartesanal
```

### **3. WhatsApp Business**
Salve o link nas respostas rápidas:
```
Olá! Para ver os chopps disponíveis agora, acesse:
https://seu-projeto.web.app
```

### **4. Instagram Bio**
```
🍺 Chopps disponíveis em tempo real
👇 Clique no link abaixo
```

---

## 📱 PWA - App Instalável (Opcional)

Transforme o site em um "app" instalável:

### **1. Editar `web/manifest.json`:**
```json
{
  "name": "ChoppFlow - Chopps Disponíveis",
  "short_name": "ChoppFlow",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#FFFFFF",
  "theme_color": "#FFA726",
  "description": "Veja os chopps disponíveis em tempo real",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### **2. Clientes podem "instalar":**
- Chrome: Menu → "Instalar app"
- Safari iOS: Compartilhar → "Adicionar à Tela de Início"

---

## 🎯 Resumo - Comandos Rápidos

### **Deploy Inicial (Firebase - RECOMENDADO):**
```bash
# Setup único
npm install -g firebase-tools
firebase login
cd /home/jeancarloscc/Documents/projects/choppflow
firebase init hosting

# Deploy
flutter build web --release
firebase deploy --only hosting
```

### **Atualizar Site:**
```bash
flutter build web --release
firebase deploy --only hosting
```

### **Ver Site:**
```
https://seu-projeto.web.app
```

---

## 🆘 Troubleshooting

### **Erro: "Firebase command not found"**
```bash
npm install -g firebase-tools
# ou
sudo npm install -g firebase-tools
```

### **Erro: "Build failed"**
```bash
flutter clean
flutter pub get
flutter build web --release
```

### **Erro: "Firebase deploy failed"**
```bash
firebase logout
firebase login
firebase deploy --only hosting
```

### **Site não carrega chopps:**
1. Verifique regras do Firestore (allow read: if true)
2. Verifique console do navegador (F12)
3. Teste localmente primeiro

---

## ✅ Checklist Final

- [ ] Instalar Firebase CLI
- [ ] Fazer login no Firebase
- [ ] Inicializar Firebase Hosting
- [ ] Build web (`flutter build web --release`)
- [ ] Deploy (`firebase deploy --only hosting`)
- [ ] Testar no navegador
- [ ] Configurar regras do Firestore (allow read)
- [ ] Gerar QR Code
- [ ] Compartilhar link com clientes
- [ ] (Opcional) Configurar domínio customizado
- [ ] (Opcional) Adicionar Google Analytics

---

## 🎉 Pronto!

Depois do deploy:
1. **Você (vendedor):** Usa o app mobile para gerenciar chopps
2. **Clientes:** Acessam o site web para ver os disponíveis
3. **Atualização automática:** Quando você altera no mobile, clientes veem em tempo real! ⚡

**URL de exemplo após deploy:**
```
https://choppflow-abc123.web.app
```

**Compartilhe essa URL com seus clientes!** 🍺📱
