;;; legibilis-theme.el --- Legibilis: Modus Vivendi Tinted at 7:1 for every color -*- lexical-binding: t -*-

;; Copyright (C) 2026 Katabex

;; Author: Katabex
;; Package-Requires: ((emacs "30.1") (modus-themes "5.0.0"))
;; SPDX-License-Identifier: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; The Emacs side of the Legibilis Omarchy theme.  It is a derivative of `modus-vivendi-tinted' built with
;; `modus-themes-theme', so every face the Modus themes support keeps
;; its design; only palette entries are replaced:
;;
;; - surfaces are a cobalt (hue 263) with the raised,
;;   halation-reducing `bg-main' #131c2f; the region is the Legibilis
;;   selection #404f6c with `fg-region' #f4f6ff (7.63:1) on it;
;; - every foreground reads at 7:1 or more on `bg-main' (WCAG AAA):
;;   the 14 Modus colors below 7:1 there are lifted, and the reds and
;;   blues are spread by hue, chroma and contrast (7-9:1) so that
;;   lifting them does not merge them; the closest pair among the
;;   changed colors is 0.043 OKLab apart, against 0.007 upstream;
;; - `red' (errors) stays within 4 degrees of its hue, `red-faint'
;;   (comments) becomes a muted terracotta, and `blue' (strings) and
;;   `blue-warmer' (keywords) stay within 8 degrees;
;; - the terminal colors match the Legibilis terminal palette, so vterm,
;;   eshell and compilation buffers look like the Ghostty windows.
;;
;; On `bg-dim' the lowest foreground reads 6.48:1 and on the current
;; line 5.60:1, as on the Neovim cursor line.  See the Legibilis README.

;;; Code:

(require 'seq)
(require 'modus-themes)

(defconst legibilis-palette-partial
  '(
    ;; Surfaces: the cobalt; the region is the Legibilis selection and
    ;; the current line the same 35% selection blend as the Neovim cursor line
    (bg-main               "#131c2f")
    (bg-dim                "#1a2335")
    (bg-inactive           "#273145")
    (bg-active             "#445169")
    (border                "#5e6879")
    (bg-hl-line            "#232e44")
    (bg-region             "#404f6c")
    (bg-mode-line-active   "#424f67")
    (bg-mode-line-inactive "#222f48")
    (border-mode-line-inactive"#5c6370")
    (bg-tab-bar            "#273245")
    (bg-tab-current        "#131c2f")
    (bg-tab-other          "#44516a")
    (bg-diff-context       "#172030")

    ;; Text: off-white against halation; dim text is the Legibilis muted (7:1)
    (fg-main               "#ebedf5")
    (fg-dim                "#9ea7b6")
    (fg-region             "#f4f6ff")
    (fg-mode-line-active   "#ebedf5")
    (fg-mode-line-inactive "#a6a7a7")

    ;; Every Modus foreground below 7:1 on bg-main, lifted to 7:1 or more.
    ;; The reds and blues are re-spread (hue, chroma and contrast 7-9:1) so
    ;; that they stay apart; `red' (errors) keeps its hue within 4 degrees.
    (red                   "#ff826f")
    (red-warmer            "#fe9c75")
    (red-cooler            "#e99eaa")
    (red-faint             "#d6978e")
    (red-intense           "#ffa49c")
    (blue                  "#3cb7ff")
    (blue-warmer           "#a4bbff")
    (blue-cooler           "#41cbfa")
    (blue-faint            "#94afd5")
    (blue-intense          "#79aeff")
    (magenta-intense       "#ff69ff")
    (gold                  "#caa064")
    (indigo                "#9aa3e3")
    (maroon                "#e08eb6")

    ;; The Legibilis green and orange
    (green                 "#65b872")
    (rust                  "#dc9940")

    ;; Terminal colors: the Legibilis terminal palette (colors.toml)
    (fg-term-black-bright  "#9ea7b6")
    (bg-term-black-bright  "#9ea7b6")
    (fg-term-red           "#ff8177")
    (bg-term-red           "#ff8177")
    (fg-term-red-bright    "#fab6b0")
    (bg-term-red-bright    "#fab6b0")
    (fg-term-green         "#65b872")
    (bg-term-green         "#65b872")
    (fg-term-green-bright  "#00e05b")
    (bg-term-green-bright  "#00e05b")
    (fg-term-yellow        "#ccb900")
    (bg-term-yellow        "#ccb900")
    (fg-term-yellow-bright "#f8bc68")
    (bg-term-yellow-bright "#f8bc68")
    (fg-term-blue          "#59acf5")
    (bg-term-blue          "#59acf5")
    (fg-term-blue-bright   "#a4c6e1")
    (bg-term-blue-bright   "#a4c6e1")
    (fg-term-magenta       "#e293cd")
    (bg-term-magenta       "#e293cd")
    (fg-term-magenta-bright"#c3b2ff")
    (bg-term-magenta-bright"#c3b2ff")
    (fg-term-cyan          "#00bed1")
    (bg-term-cyan          "#00bed1")
    (fg-term-cyan-bright   "#58dcb9")
    (bg-term-cyan-bright   "#58dcb9")
    (fg-term-white         "#ebedf5")
    (bg-term-white         "#ebedf5")
    (fg-term-white-bright  "#f4f6ff")
    (bg-term-white-bright  "#f4f6ff"))
  "Palette entries where Legibilis differs from `modus-vivendi-tinted'.")

(defconst legibilis-palette
  (append
   ;; Replace upstream entries in place so each name appears once.
   (mapcar (lambda (entry)
             (or (assq (car entry) legibilis-palette-partial) entry))
           modus-themes-vivendi-tinted-palette)
   ;; Entries that upstream defines elsewhere (terminal mappings).
   (seq-remove (lambda (entry)
                 (assq (car entry) modus-themes-vivendi-tinted-palette))
               legibilis-palette-partial))
  "The full Legibilis palette.")

(defvar legibilis-palette-user nil
  "User-defined extensions to `legibilis-palette'.")

(defvar legibilis-palette-overrides nil
  "User overrides for `legibilis-palette', as in `modus-themes-common-palette-overrides'.")

(modus-themes-theme
 'legibilis
 'legibilis
 "Modus Vivendi Tinted on a raised cobalt, every color at 7:1 or more.
A raised, halation-reducing background with off-white text, derived
from `modus-vivendi-tinted'."
 'dark
 'legibilis-palette
 'legibilis-palette-user
 'legibilis-palette-overrides)

;;; legibilis-theme.el ends here
