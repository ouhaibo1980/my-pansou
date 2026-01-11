import { NextRequest, NextResponse } from 'next/server';

// 设置更长的超时时间（60秒）
const FETCH_TIMEOUT = 60000;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const keyword = searchParams.get('keyword');

    if (!keyword) {
      return NextResponse.json(
        { code: -1, message: '缺少关键词参数' },
        { status: 400 }
      );
    }

    // 代理请求到后端 API（后端期望的参数名是 kw，不是 keyword）
    const backendUrl = `http://localhost:8888/api/search?kw=${encodeURIComponent(keyword)}`;
    
    // 创建超时控制器
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), FETCH_TIMEOUT);
    
    const response = await fetch(backendUrl, {
      cache: 'no-store',
      signal: controller.signal,
    });
    
    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`Backend API returned ${response.status}`);
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error('API Proxy Error:', error);
    return NextResponse.json(
      { code: -1, message: '搜索服务暂时不可用' },
      { status: 500 }
    );
  }
}
