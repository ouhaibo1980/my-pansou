import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

// 读取环境变量中的项目名称
const appName = process.env.NEXT_PUBLIC_APP_NAME || "装歌盘搜";

export const metadata: Metadata = {
  title: `${appName} - 网盘资源搜索引擎`,
  description: `高性能网盘资源搜索引擎，支持 77 个搜索源插件`,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN">
      <body className={`${inter.variable} antialiased`}>
        {children}
      </body>
    </html>
  );
}
