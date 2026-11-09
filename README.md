# Quadro de Missões

Gerenciador de campanhas de RPG (Tormenta20 e sistema próprio): quadro de missões, mapa interativo, fichas e grupo.

O app inteiro está em `www/index.html` (um arquivo só). O Android é gerado com o [Capacitor](https://capacitorjs.com).

## Gerar o APK pelo GitHub (sem instalar nada)

1. Crie um repositório no GitHub e envie estes arquivos (pasta `.github` incluída).
2. A cada envio para a branch `main`, a aba **Actions** roda "Gerar APK".
   Também dá para rodar na mão: Actions → Gerar APK → *Run workflow*.
3. Quando terminar (uns 5 min), abra a execução e baixe **quadro-de-missoes-apk** em *Artifacts*.
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

## Contas de teste

Senha `123456`: `mestre@teste.com`, `jogador1@teste.com`, `jogador2@teste.com`, `jogador3@teste.com`.
Na tela de login dá para restaurar os dados de teste.

## Observações

- **Dados:** por enquanto ficam salvos no próprio aparelho (localStorage). O rascunho do banco
  para o Supabase está em `supabase/schema.sql`.
- **Internet:** o leitor de PDF de fichas e as fontes vêm de CDN na primeira vez; mapas por URL
  também precisam de internet.
- **Imagens dos mapas:** não vêm no app. O preset Tormenta 20 usa um endereço (URL) para Arton;
  nos outros mapas, informe a imagem em ⚙ Configurações do mapa.
- **Seleção de arquivos (PDF/imagens):** funciona no APK, porque a WebView do Capacitor abre o
  seletor do Android.
- **APK de teste (debug):** serve para instalar e testar. Para publicar na Play Store, é preciso
  gerar um `.aab` assinado (`./gradlew bundleRelease` com uma keystore).

## Próximos passos com o Supabase

1. Criar o projeto e rodar `supabase/schema.sql` no SQL Editor.
2. Ativar RLS em todas as tabelas e criar políticas: mestre lê/escreve tudo da campanha;
   jogador lê missões visíveis, as próprias fichas e as compartilhadas; anotações só do autor.
3. Trocar a camada `DB` do `index.html` (load/save) por chamadas ao `supabase-js`.
