import { NextRequest, NextResponse } from 'next/server';

// 设置更长的超时时间（60秒）
const FETCH_TIMEOUT = 60000;

// 从环境变量获取后端地址，默认使用 localhost:8888
const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:8888';

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
    console.log(`[API Search] Backend URL: ${BACKEND_URL}`);

    // 代理请求到后端 API（后端期望的参数名是 kw，不是 keyword）
    // 添加 refresh=true 参数，确保获取最新搜索结果
    const backendUrl = `${BACKEND_URL}/api/search?kw=${encodeURIComponent(keyword)}&refresh=true`;
    
    console.log(`[API Search] Full Backend URL: ${backendUrl}`);
    
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
      const errorText = await response.text();
      console.error(`[API Search] Backend error response: ${errorText}`);
      throw new Error(`Backend API returned ${response.status}: ${errorText}`);
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error('[API Search] Error:', error);
    
    // 判断错误类型，返回更友好的错误信息
    let errorMessage = '搜索服务暂时不可用';
    
    if (error instanceof Error) {
      if (error.name === 'AbortError') {
        errorMessage = '请求超时，请稍后重试';
      } else if (error.message.includes('ECONNREFUSED')) {
        errorMessage = '无法连接到后端服务，请检查后端是否启动';
      } else if (error.message.includes('ENOTFOUND')) {
        errorMessage = '无法解析后端服务地址';
      } else {
        errorMessage = `搜索失败: ${error.message}`;
      }
    }
    
    return NextResponse.json(
      { code: -1, message: errorMessage },
      { status: 500 }
    );
  }
}
