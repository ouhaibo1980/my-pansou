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

    console.log(`[API Search] Searching for: ${keyword}`);

    // 根据当前请求动态构建后端 URL
    const protocol = request.headers.get('x-forwarded-proto') || request.nextUrl.protocol.replace(':', '');
    const host = request.headers.get('x-forwarded-host') || request.headers.get('host') || 'localhost:5000';

    // 构建后端 URL：使用相同的域名和协议，但端口改为 8888
    const backendHost = host.replace(/:\d+$/, ':8888');
    const backendUrl = `${protocol}://${backendHost}/api/search?kw=${encodeURIComponent(keyword)}&refresh=true`;

    console.log(`[API Search] Backend URL: ${backendUrl}`);
    
    // 创建超时控制器
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), FETCH_TIMEOUT);
    
    console.log(`[API Search] Starting fetch...`);
    const response = await fetch(backendUrl, {
      cache: 'no-store',
      signal: controller.signal,
    });
    
    clearTimeout(timeoutId);
    
    console.log(`[API Search] Response status: ${response.status}`);

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
