{{flutter_js}}
{{flutter_build_config}}

// Hide the branded splash (see index.html) once the first frame is up.
_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    const loader = document.getElementById('loader');
    if (loader) {
      loader.classList.add('done');
      setTimeout(() => loader.remove(), 450);
    }
  },
});
