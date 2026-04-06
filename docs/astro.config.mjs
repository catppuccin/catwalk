// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import catppuccin from "@catppuccin/starlight";
import { remarkHeadingId } from "remark-custom-heading-id";
import starlightLinksValidator from "starlight-links-validator";
import starlightChangelogs from "starlight-changelogs";

// https://astro.build/config
export default defineConfig({
  site: "https://catwalk.catppuccin.com",
  markdown: {
    remarkPlugins: [remarkHeadingId],
  },
  integrations: [
    starlight({
      title: "Catppuccin Catwalk",
      favicon: "/favicon.png",
      logo: {
        dark: "/public/pepperjack-dark.png",
        light: "/public/pepperjack-light.png",
      },
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/catppuccin/catwalk",
        },
      ],
      editLink: {
        baseUrl: "https://github.com/catppuccin/catwalk/edit/main/docs",
      },
      expressiveCode: {
        themes: ["catppuccin-mocha", "catppuccin-latte"],
        styleOverrides: {
          frames: {
            tooltipSuccessBackground: "var(--green)",
            tooltipSuccessForeground: "var(--base)",
          },
          textMarkers: {
            insBackground:
              "color-mix(in oklab, var(--sl-color-green-high) 25%, var(--sl-color-gray-6));",
            insBorderColor: "var(--sl-color-gray-5)",
            delBackground:
              "color-mix(in oklab, var(--sl-color-red-high) 25%, var(--sl-color-gray-6));",
            delBorderColor: "var(--sl-color-gray-5)",
          },
          codeBackground: "var(--sl-color-gray-6)",
        },
      },
      sidebar: [
        {
          label: "Getting Started",
          autogenerate: { directory: "getting-started" },
        },
      ],
      plugins: [catppuccin(), starlightLinksValidator(), starlightChangelogs()],
    }),
  ],
});
