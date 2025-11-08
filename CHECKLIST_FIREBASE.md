# 🔍 Checklist - Verificar Configuração do Firebase

## ⚠️ Erro Persistente: "Erro ao carregar chopps"

Se o erro continua aparecendo, siga este checklist passo a passo:

---

## 📋 Passo 1: Verificar se o Firestore está Ativado

### **1.1 Acessar o Console do Firebase:**
- 🔗 https://console.firebase.google.com/project/choppflow-app/firestore

### **1.2 Verificar se o Firestore Database está criado:**
- ✅ **Se aparecer a interface do Firestore com abas "Dados", "Regras", "Índices":**
  - Firestore está ativado ✓

- ❌ **Se aparecer um botão "Criar banco de dados" ou "Get started":**
  - Firestore **NÃO** está ativado!
  - **Solução:** Clique em "Criar banco de dados"
  - Escolha: **"Começar no modo de produção"**
  - Localização: **nam5 (us-central)** ou a mais próxima
  - Clique em "Ativar"

---

## 📋 Passo 2: Verificar Regras do Firestore

### **2.1 Acessar as Regras:**
- Console Firebase → Firestore Database → **Regras** (aba superior)

### **2.2 Verificar se as regras permitem leitura pública:**

**Deve estar assim:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{itemId} {
      allow read: if true;
      allow write: if true;
    }
    match /history/{historyId} {
      allow read: if true;
      allow write: if true;
    }
  }
}
```

**Se estiver diferente (exemplo de regras bloqueadas):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;  // ← BLOQUEADO!
    }
  }
}
```

**Solução:**
1. Copie as regras corretas (acima)
2. Cole no editor de regras
3. Clique em **"Publicar"**

---

## 📋 Passo 3: Verificar se Há Dados no Firestore

### **3.1 Acessar os Dados:**
- Console Firebase → Firestore Database → **Dados** (aba superior)

### **3.2 Verificar a coleção `items`:**

**Cenário 1: Coleção `items` não existe**
- ❌ Se não aparecer nenhuma coleção chamada `items`
- **Solução:** Você precisa criar dados!

**Como criar:**

#### **Opção A: Criar manualmente no console**
1. Clique em **"Iniciar coleção"**
2. ID da coleção: `items`
3. Clique em "Próxima"
4. Adicione os campos:

```
Campo: name
Tipo: string
Valor: Brahma Chopp

Campo: price  
Tipo: number
Valor: 15

Campo: description
Tipo: string
Valor: Chopp Brahma gelado

Campo: available
Tipo: boolean
Valor: true
```

5. Clique em **"Salvar"**

#### **Opção B: Usar o app mobile**
```bash
flutter run
```
Adicione chopps pelo app e eles aparecerão automaticamente no Firestore.

**Cenário 2: Coleção existe mas está vazia**
- Adicione documentos conforme Opção A ou B acima

**Cenário 3: Tem documentos mas `available: false`**
- O site só mostra chopps com `available: true`
- Edite os documentos e mude `available` para `true`

---

## 📋 Passo 4: Verificar Configuração Web do Firebase

### **4.1 Acessar Configurações do Projeto:**
- Console Firebase → ⚙️ (engrenagem) → **Configurações do projeto**

### **4.2 Rolar até "Seus aplicativos"**
- Deve ter um app Web (ícone `</>`）

### **4.3 Clicar em "Web app" para ver as credenciais:**

**Verificar se o `projectId` está correto:**
```javascript
const firebaseConfig = {
  projectId: "choppflow-app",  // ← Deve ser exatamente isso
  // ...
};
```

### **4.4 Comparar com o arquivo local:**
```bash
cat lib/firebase_options.dart | grep projectId
```

**Deve retornar:**
```
projectId: 'choppflow-app',
```

Se estiver diferente, copie as configurações corretas do console.

---

## 📋 Passo 5: Verificar URL da API do Firestore

### **5.1 No Console do Firebase:**
- Firestore Database → ⚙️ Configurações

### **5.2 Verificar URL da API:**
Deve ser algo como:
```
https://firestore.googleapis.com/v1/projects/choppflow-app/databases/(default)/documents
```

Se não conseguir acessar essa URL, o Firestore pode não estar ativado corretamente.

---

## 📋 Passo 6: Testar Conexão Manualmente

### **6.1 Abrir o site publicado:**
```
https://choppflow-app.web.app
```

### **6.2 Abrir Console do Navegador:**
- Pressione **F12** (ou Ctrl+Shift+I)
- Vá na aba **Console**

### **6.3 Procurar por erros:**

**Erros Comuns:**

**Erro 1: CORS / Cross-Origin**
```
Access to XMLHttpRequest at 'https://firestore.googleapis.com/...' from origin 'https://choppflow-app.web.app' has been blocked by CORS policy
```
**Solução:** Não deveria acontecer com Firebase Hosting, mas se acontecer:
- Rebuild e redeploy: `flutter build web --release && firebase deploy --only hosting`

**Erro 2: Permission Denied**
```
FirebaseError: Missing or insufficient permissions
```
**Solução:** As regras do Firestore estão bloqueando. Veja Passo 2.

**Erro 3: Project not found**
```
Project 'choppflow-app' not found
```
**Solução:** Verificar `firebase_options.dart` tem o `projectId` correto.

**Erro 4: Firestore not initialized**
```
Firestore has not been initialized
```
**Solução:** Firestore não foi criado. Veja Passo 1.

---

## 🔧 Comandos para Forçar Atualização

Se tudo estiver correto mas ainda não funciona:

### **Rebuild completo:**
```bash
cd /home/jeancarloscc/Documents/projects/choppflow

# Limpar tudo
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Reinstalar dependências
flutter pub get

# Build web novamente
flutter build web --release

# Redeploy
firebase deploy --only hosting

# Redeploy regras também
firebase deploy --only firestore:rules
```

---

## 🧪 Teste Local antes do Deploy

Antes de fazer deploy, teste localmente para ver o erro real:

```bash
# Executar localmente
flutter run -d chrome

# Abrir console do navegador (F12)
# Ver erros detalhados
```

---

## 📝 Checklist Resumido

Marque cada item conforme verifica:

### **No Console do Firebase:**
- [ ] Firestore Database está ativado (não pede para criar)
- [ ] Collection `items` existe
- [ ] Há pelo menos 1 documento em `items`
- [ ] Documento tem campo `available: true`
- [ ] Regras permitem `allow read: if true`
- [ ] App Web está registrado em Configurações do Projeto
- [ ] `projectId` é "choppflow-app"

### **No Código Local:**
- [ ] Arquivo `firebase_options.dart` tem `projectId: 'choppflow-app'`
- [ ] Arquivo `firestore.rules` tem `allow read: if true`
- [ ] Build web foi feito: `flutter build web --release`
- [ ] Deploy foi feito: `firebase deploy`

### **No Navegador:**
- [ ] Site carrega: https://choppflow-app.web.app
- [ ] Console do navegador (F12) não mostra erros
- [ ] Se mostrar erro, anotar qual é

---

## 🎯 Próximo Passo Baseado no Resultado

### **Se "Nenhum chopp disponível no momento":**
✅ **Ótimo! O Firebase está conectando!**
- Problema: Não há chopps no banco ou todos estão com `available: false`
- Solução: Adicionar chopps (veja Passo 3)

### **Se "Erro ao carregar chopps":**
❌ **Ainda há problema de conexão**
- Verificar TODOS os itens do checklist acima
- Executar `flutter run -d chrome` e ver erro no console
- Copiar e colar o erro exato aqui

### **Se aparecer lista de chopps:**
🎉 **FUNCIONA! Está tudo certo!**
- Só precisa adicionar mais chopps
- Compartilhar o link com clientes

---

## 📱 Contatos Úteis

### **Console Firebase:**
- 🔗 Visão Geral: https://console.firebase.google.com/project/choppflow-app/overview
- 🔗 Firestore: https://console.firebase.google.com/project/choppflow-app/firestore
- 🔗 Regras: https://console.firebase.google.com/project/choppflow-app/firestore/rules
- 🔗 Hosting: https://console.firebase.google.com/project/choppflow-app/hosting

### **Site Publicado:**
- 🔗 https://choppflow-app.web.app

---

## 🆘 Se Nada Funcionar

Execute estes comandos e me envie a saída:

```bash
# 1. Verificar se está logado
firebase projects:list

# 2. Ver regras atuais
cat firestore.rules

# 3. Ver configuração do Firebase
cat lib/firebase_options.dart | grep -A 5 "web ="

# 4. Testar localmente e copiar o erro
flutter run -d chrome
# (Abrir F12, copiar erro do Console)

# 5. Verificar status do deploy
firebase hosting:channel:list
```

Envie o resultado de cada comando para identificarmos o problema exato.
