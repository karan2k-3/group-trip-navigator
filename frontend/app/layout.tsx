import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Wayfinder — AI Travel Agent",
  description: "An AI agent that plans trips: live weather, flights, and attractions.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
