'use client';

import { useState } from 'react';
import { Search, Globe, Download, Clock, ExternalLink, Copy } from 'lucide-react';

interface SearchResult {
  title: string;
  url: string;
  time: string;
  type: string;
  size?: string;
}

export default function Home() {
  const [keyword, setKeyword] = useState('');
  const [searching, setSearching] = useState(false);
  const [results, setResults] = useState<SearchResult[]>([]);
  const [error, setError] = useState('');

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!keyword.trim()) return;

    setSearching(true);
    setError('');
    setResults([]);

    try {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://my79h7pf6d.coze.site';
      const response = await fetch(`${apiUrl}/api/search?keyword=${encodeURIComponent(keyword)}`);
      const data = await response.json();

      if (data.code === 0 && data.data.merged_by_type) {
        // 将后端返回的 merged_by_type 结构转换为前端需要的 results 数组
        const convertedResults: SearchResult[] = [];
        const typeMapping: { [key: string]: string } = {
          'xunlei': '迅雷',
          'uc': 'UC',
          'baidu': '百度',
          'quark': '夸克',
          'aliyun': '阿里云',
          'tianyi': '天翼',
          '115': '115',
          'pikpak': 'PikPak',
          'magnet': '磁力'
        };

        // 遍历所有类型
        for (const [type, items] of Object.entries(data.data.merged_by_type)) {
          if (Array.isArray(items)) {
            // 为每个结果添加类型信息
            items.forEach((item: any) => {
              convertedResults.push({
                title: item.note || item.title || '未命名资源',
                url: item.url,
                time: formatTime(item.datetime),
                type: typeMapping[type] || type,
                size: item.size
              });
            });
          }
        }

        setResults(convertedResults);
      } else {
        setError('未找到相关结果');
      }
    } catch (err) {
      console.error('Search error:', err);
      setError('搜索失败，请稍后重试');
    } finally {
      setSearching(false);
    }
  };

  const formatTime = (datetime: string): string => {
    if (!datetime || datetime === '0001-01-01T00:00:00Z') {
      return '未知时间';
    }
    try {
      const date = new Date(datetime);
      const now = new Date();
      const diff = now.getTime() - date.getTime();
      const days = Math.floor(diff / (1000 * 60 * 60 * 24));

      if (days === 0) {
        return '今天';
      } else if (days === 1) {
        return '昨天';
      } else if (days < 7) {
        return `${days}天前`;
      } else {
        return date.toLocaleDateString('zh-CN');
      }
    } catch {
      return datetime.split('T')[0] || datetime;
    }
  };

  const getPanTypeIcon = (type: string) => {
    switch (type) {
      case '百度': return '百度';
      case '阿里云': return '阿里云';
      case '夸克': return '夸克';
      case '天翼': return '天翼';
      case 'UC': return 'UC';
      case '115': return '115';
      case 'PikPak': return 'PikPak';
      case '迅雷': return '迅雷';
      case '磁力': return '磁力';
      default: return type || '其他';
    }
  };

  const getPanTypeColor = (type: string) => {
    switch (type) {
      case '百度': return 'bg-blue-500';
      case '阿里云': return 'bg-orange-500';
      case '夸克': return 'bg-purple-500';
      case '天翼': return 'bg-cyan-500';
      case 'UC': return 'bg-yellow-500';
      case '115': return 'bg-green-500';
      case 'PikPak': return 'bg-pink-500';
      case '迅雷': return 'bg-red-500';
      case '磁力': return 'bg-purple-600';
      default: return 'bg-gray-500';
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* Header */}
        <header className="text-center mb-12">
          <h1 className="text-5xl font-bold text-white mb-4 flex items-center justify-center gap-3">
            <Globe className="w-12 h-12 text-purple-400" />
            PanSou
          </h1>
          <p className="text-xl text-purple-200">高性能网盘资源搜索引擎</p>
        </header>

        {/* Search Form */}
        <form onSubmit={handleSearch} className="max-w-3xl mx-auto mb-12">
          <div className="relative group">
            <input
              type="text"
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              placeholder="搜索网盘资源..."
              className="w-full px-6 py-5 pr-14 text-lg rounded-2xl bg-white/10 backdrop-blur-lg border border-white/20 text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all group-hover:bg-white/15"
              disabled={searching}
            />
            <button
              type="submit"
              disabled={searching}
              className="absolute right-2 top-1/2 -translate-y-1/2 p-2.5 bg-purple-600 hover:bg-purple-700 disabled:bg-purple-400 rounded-xl text-white transition-colors disabled:cursor-not-allowed"
            >
              {searching ? (
                <div className="w-6 h-6 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <Search className="w-6 h-6" />
              )}
            </button>
          </div>
        </form>

        {/* Error Message */}
        {error && (
          <div className="max-w-3xl mx-auto mb-8 p-4 bg-red-500/20 border border-red-500/50 rounded-xl text-red-200">
            {error}
          </div>
        )}

        {/* Search Results */}
        {results.length > 0 && (
          <div className="max-w-4xl mx-auto">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-white">
                搜索结果 <span className="text-purple-400">({results.length})</span>
              </h2>
              <span className="text-purple-300 text-sm">关键词: {keyword}</span>
            </div>

            <div className="space-y-4">
              {results.map((result, index) => (
                <ResultCard
                  key={index}
                  result={result}
                  getPanTypeIcon={getPanTypeIcon}
                  getPanTypeColor={getPanTypeColor}
                />
              ))}
            </div>
          </div>
        )}

        {/* No Results */}
        {searching === false && results.length === 0 && keyword && !error && (
          <div className="max-w-3xl mx-auto text-center py-12">
            <Search className="w-24 h-24 mx-auto text-white/20 mb-4" />
            <p className="text-xl text-white/50">未找到相关资源</p>
            <p className="text-white/30 mt-2">试试其他关键词</p>
          </div>
        )}
      </div>
    </div>
  );
}

function ResultCard({
  result,
  getPanTypeIcon,
  getPanTypeColor,
}: {
  result: SearchResult;
  getPanTypeIcon: (type: string) => string;
  getPanTypeColor: (type: string) => string;
}) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(result.url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  };

  return (
    <div className="p-5 bg-white/5 backdrop-blur-lg rounded-xl border border-white/10 hover:bg-white/10 transition-all hover:border-purple-500/50 group">
      <div className="flex items-start gap-4">
        <div className={`px-3 py-1.5 rounded-lg text-white text-sm font-medium ${getPanTypeColor(result.type)}`}>
          {getPanTypeIcon(result.type)}
        </div>

        <div className="flex-1 min-w-0">
          <h3 className="text-lg font-semibold text-white mb-2 group-hover:text-purple-400 transition-colors line-clamp-2">
            {result.title}
          </h3>

          <div className="flex items-center gap-4 text-sm text-purple-300/70">
            {result.size && (
              <span className="flex items-center gap-1.5">
                <Download className="w-4 h-4" />
                {result.size}
              </span>
            )}
            {result.time && (
              <span className="flex items-center gap-1.5">
                <Clock className="w-4 h-4" />
                {result.time}
              </span>
            )}
          </div>
        </div>

        <div className="flex items-center gap-2">
          <a
            href={result.url}
            target="_blank"
            rel="noopener noreferrer"
            className="px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-lg text-sm font-medium transition-colors flex items-center gap-2"
          >
            打开
            <ExternalLink className="w-4 h-4" />
          </a>

          <button
            onClick={handleCopy}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors flex items-center gap-2 ${
              copied
                ? 'bg-green-600 text-white'
                : 'bg-white/10 hover:bg-white/20 text-white'
            }`}
          >
            {copied ? (
              <>
                已复制
              </>
            ) : (
              <>
                复制
                <Copy className="w-4 h-4" />
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
