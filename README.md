# Omni RP

Gerenciador de campanhas de RPG (Tormenta20 e sistema próprio): quadro de missões, mapa interativo, fichas e grupo.

O app inteiro está em `www/index.html` (um arquivo só). Ícone, tela de abertura e logos ficam em `resources/` (o workflow copia os ícones para o Android). O Android é gerado com o [Capacitor](https://capacitorjs.com).

## Gerar o APK pelo GitHub (sem instalar nada)

1. Crie um repositório no GitHub e envie estes arquivos (pasta `.github` incluída).
2. A cada envio para a branch `main`, a aba **Actions** roda "Gerar APK".
   Também dá para rodar na mão: Actions → Gerar APK → *Run workflow*.
3. Quando terminar (uns 5 min), abra a execução e baixe **omni-rp-apk** em *Artifacts*.
   Dentro do zip está o `app-debug.apk` para instalar no celular
   (permita "instalar apps de fontes desconhecidas").

## Gerar o APK no computador

Precisa de Node 20, JDK 17 e Android Studio (Android SDK).

```bash
npm install
npx cap add android      # só na primeira vez
npm run android:build    # APK em android/app/build/outputs/apk/debug/
# ou abra no Android Studio:
npm run android:open
```

Depois de mudar o `www/index.html`, rode `npx cap sync android` (ou `npm run android:build`).

## Layouts das campanhas

Na aba ⚙ Ajustes de cada campanha, o mestre escolhe entre Medieval (padrão), Ciberpunk, Steampunk, Modern e Omni.
O layout vale para todos os participantes daquela campanha. Fora das campanhas o app usa o visual Omni.

## Contas

O APK não tem contas de teste: cada pessoa cria a própria conta (salva no Supabase).
Se o login pedir confirmação de e-mail, desligue em Supabase → Authentication → Sign In / Providers → Email → *Confirm email*.

## Observações

- **Dados:** sem Supabase configurado, ficam no próprio aparelho (modo de teste). Com o Supabase,
  ficam no servidor (veja abaixo).
- **Internet:** o leitor de PDF de fichas e as fontes vêm de CDN na primeira vez; mapas por URL
  também precisam de internet.
- **Imagens dos mapas:** não vêm no app. O preset Tormenta 20 usa um endereço (URL) para Arton;
  nos outros mapas, informe a imagem em ⚙ Configurações do mapa.
- **Seleção de arquivos (PDF/imagens):** funciona no APK, porque a WebView do Capacitor abre o
  seletor do Android.
- **APK de teste (debug):** serve para instalar e testar. Para publicar na Play Store, é preciso
  gerar um `.aab` assinado (`./gradlew bundleRelease` com uma keystore).

## Ligar ao Supabase (contas e dados online)

1. Crie um projeto em [supabase.com](https://supabase.com) (plano gratuito serve).
2. **SQL Editor → New query**: cole o conteúdo de `supabase/setup.sql` e clique em **Run**.
3. **Authentication → Sign In / Providers → Email**: desligue **Confirm email**
   (assim os amigos entram logo depois de criar a conta, sem precisar confirmar por e-mail).
4. **Project Settings → API**: copie a **Project URL** e a chave **anon public**.
5. No `www/index.html`, procure por `SUPABASE_URL` e preencha:
   ```js
   const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
   const SUPABASE_KEY = 'sua-chave-anon-public';
   ```
6. Envie para o GitHub: o Actions gera o novo APK.

Com as duas linhas preenchidas, o app passa a usar contas reais (e-mail e senha), salva tudo no
servidor e sincroniza em tempo real entre os celulares. As contas de teste somem. Com as linhas
vazias, ele volta ao modo local de teste.

Cada amigo cria a conta pelo próprio app. O mestre cria a campanha e passa o código, ou convida
pelo e-mail da conta.

**Segurança:** é um modelo para grupo de amigos. Qualquer pessoa com conta consegue ler os dados
da mesa (a chave `anon` fica dentro do APK). Para fechar, desligue **Allow new users to sign up**
em Authentication depois que todos tiverem conta.
