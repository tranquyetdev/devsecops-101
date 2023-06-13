import { isOdd } from '@aws-cloud-pratice/is-odd';

export async function GET(request: Request) {
  return new Response(JSON.stringify({ isOdd: isOdd(new Date().getTime()) }));
}
