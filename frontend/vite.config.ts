import react from '@vitejs/plugin-react';
import { defineConfig, loadEnv } from 'vite';
import svgr from 'vite-plugin-svgr';

export default defineConfig(({ mode }) => {
  // 모드에 따라 환경 변수 로드
  const env = loadEnv(mode, process.cwd(), '');

  return {
    plugins: [react(), svgr()],
    base: env.VITE_BASE_URL ? env.VITE_BASE_URL : '/', // 환경 변수 사용
    server: {
      port: 3333,
    },
    resolve: {
      alias: [
        { find: '@', replacement: '/src' },
        { find: '@api', replacement: '/src/api' },
        { find: '@assets', replacement: '/src/assets' },
        { find: '@components', replacement: '/src/components' },
        { find: '@global', replacement: '/src/global' },
        { find: '@hooks', replacement: '/src/hooks' },
        { find: '@pages', replacement: '/src/pages' },
        { find: '@routes', replacement: '/src/routes' },
      ],
    },
    build: {
      rollupOptions: {
        onwarn: (warning, warn) => {
          if (warning.code === 'MODULE_LEVEL_DIRECTIVE') {
            return;
          }
          warn(warning);
        },
      },
    },
  };
});
