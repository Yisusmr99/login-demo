import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    server: {
        host: '0.0.0.0', // <--- muy importante
        port: 5173,
        strictPort: true, // opcionalmente fuerza a no cambiar de puerto
        hmr: {
            host: 'localhost', // puedes poner host.docker.internal si es necesario
        },
    },
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
    ],
});
