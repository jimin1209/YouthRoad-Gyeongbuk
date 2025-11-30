// FILE: worker/index.js
const API_BASE = 'https://gbyouth.co.kr';
const CACHE_TTL_MS = 5 * 60 * 1000; // 5 minutes

/**
 * In-memory cache structure: { key: { timestamp: number, body: string } }
 */
const memoryCache = new Map();

export default {
  async fetch(request) {
    try {
      const url = new URL(request.url);
      if (url.pathname === '/policy/list') {
        return await handlePolicyList(url);
      }

      return new Response(
        JSON.stringify({ message: 'Not Found' }),
        {
          status: 404,
          headers: { 'content-type': 'application/json;charset=UTF-8' },
        },
      );
    } catch (error) {
      return new Response(
        JSON.stringify({ message: 'Internal Error', error: String(error) }),
        {
          status: 500,
          headers: { 'content-type': 'application/json;charset=UTF-8' },
        },
      );
    }
  },
};

async function handlePolicyList(url) {
  const cacheKey = url.search || 'default';
  const now = Date.now();
  const cached = memoryCache.get(cacheKey);

  if (cached && now - cached.timestamp < CACHE_TTL_MS) {
    return new Response(cached.body, {
      status: 200,
      headers: {
        'content-type': 'application/json;charset=UTF-8',
        'x-cache': 'HIT',
      },
    });
  }

  const upstreamUrl = new URL('/openapi/policy/list.json', API_BASE);
  upstreamUrl.search = url.searchParams.toString();

  try {
    const upstream = await fetch(upstreamUrl.toString(), {
      method: 'GET',
      headers: {
        accept: 'application/json',
      },
    });

    if (!upstream.ok) {
      const message = await upstream.text();
      return new Response(
        JSON.stringify({
          message: 'Upstream request failed',
          status: upstream.status,
          body: message,
        }),
        {
          status: 500,
          headers: { 'content-type': 'application/json;charset=UTF-8' },
        },
      );
    }

    const body = await upstream.text();
    memoryCache.set(cacheKey, { timestamp: now, body });

    return new Response(body, {
      status: 200,
      headers: {
        'content-type': 'application/json;charset=UTF-8',
        'x-cache': 'MISS',
      },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({
        message: 'Failed to fetch upstream',
        error: String(error),
      }),
      {
        status: 502,
        headers: { 'content-type': 'application/json;charset=UTF-8' },
      },
    );
  }
}
