import { useEffect } from 'react';
import { APP_VERSION } from '../version';

const CHECK_INTERVAL = 60 * 1000; // Check every 1 minute

const VersionManager = () => {
    useEffect(() => {
        const checkForUpdate = async () => {
            try {
                // Add timestamp to prevent caching of version.json
                const response = await fetch(`/version.json?t=${Date.now()}`);
                if (!response.ok) return;

                const data = await response.json();
                const latestVersion = data.timestamp;
                const currentVersion = APP_VERSION.timestamp;

                if (latestVersion && latestVersion > currentVersion) {
                    console.log('New version detected. Reloading...');
                    // Clear cache and reload
                    if ('caches' in window) {
                        try {
                            const names = await caches.keys();
                            await Promise.all(names.map(name => caches.delete(name)));
                        } catch (e) {
                            console.error('Error clearing cache:', e);
                        }
                    }
                    window.location.reload();
                }
            } catch (error) {
                console.error('Failed to check version:', error);
            }
        };

        const interval = setInterval(checkForUpdate, CHECK_INTERVAL);

        // Initial check after 5 seconds to catch immediate updates after sleep
        const initialTimer = setTimeout(checkForUpdate, 5000);

        return () => {
            clearInterval(interval);
            clearTimeout(initialTimer);
        };
    }, []);

    return null; // This component doesn't render anything
};

export default VersionManager;
