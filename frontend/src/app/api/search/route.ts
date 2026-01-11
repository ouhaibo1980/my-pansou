import { NextRequest, NextResponse } from 'next/server';

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

    // 代理请求到后端 API
    const backendUrl = `http://localhost:8888/api/search?keyword=${encodeURIComponent(keyword)}`;
    const response = await fetch(backendUrl, {
      cache: 'no-store',
    });

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
