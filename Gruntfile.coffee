module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  grunt.initConfig
    llr:

      app:   "client"
      srv:   "server"

      tmp:   ".tmp"
      dist:  "public"


    express:
      options:
        cmd: "coffee"

      dev:
        options:
          script: "llr.coffee"
          node_env: "development"
          port: process.env.PORT or 8000

      prod:
        options:
          script: "llr.coffee"
          node_env: "production"
          port: process.env.PORT or 80


    prettify:
      dist:
        expand: true
        cwd:  "<%= llr.dist %>"
        src:  "**/*.html"
        dest: "<%= llr.dist %>"

    watch:
      views_templates:
        files: [
          "<%= llr.app %>/**/*.jade",
          "!<%= llr.app %>/index.jade"
        ]
        tasks: [ "newer:jade:templates" ]
      views_index:
        files: [ "<%= llr.app %>/index.jade" ]
        tasks: [ "newer:jade:index" ]

      scripts:
        files: ["<%= llr.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      styles:
        files: ["<%= llr.app %>/**/*.sass"]
        tasks: [ "compass:dev", "autoprefixer" ]

      livereload_css:
        options: livereload: true
        files: [ "<%= llr.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= llr.dist %>/index.html"
          "<%= llr.tmp %>/**/*.html"
          "<%= llr.tmp %>/**/*.js"
        ]

      livereload_js:
        options: livereload: true
        files: [ "<%= llr.app %>/**/*.js" ]

      express:
        options:
          livereload: true
          nospawn: true
          debounceDelay: 4000
        files: [ "<%= llr.srv %>/**/*.coffee", "llr.coffee" ]
        tasks: ["express:dev"]

      css:
        files: ["<%= llr.app %>/**/*.css"]
        tasks: [ "newer:copy:styles_tmp", "autoprefixer" ]

      gruntfile: files: ["Gruntfile.{js,coffee}"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= llr.tmp %>/*"
            "<%= llr.dist %>/*"
          ]
        ]


    jade:
      index:
        expand: true
        cwd:    "<%= llr.app %>"
        src:    [ "index.jade" ]
        dest:   "<%= llr.dist %>"
        ext:    ".html"
      templates:
        expand: true
        cwd:    "<%= llr.app %>"
        src:    [ "**/*.jade", "!index.jade" ]
        dest:   "<%= llr.tmp %>"
        ext:    ".html"


    autoprefixer:
      options: browsers: ["last 1 version"]
      dist:
        expand: true
        cwd:    "<%= llr.tmp %>"
        src:    [ "**/*.css" ]
        dest:   "<%= llr.tmp %>"


    coffee:
      dist:
        options: sourceMap: false
        files: [
          expand: true
          cwd:  "<%= llr.app %>"
          src:  "**/*.coffee"
          dest: "<%= llr.tmp %>"
          ext: ".js"
        ]
      dev:
        options:
          sourceMap: true
          sourceRoot: ""
        files: "<%= coffee.dist.files %>"


    compass:
      options:
        sassDir:                 "<%= llr.app %>"
        cssDir:                  "<%= llr.tmp %>"
        imagesDir:               "<%= llr.app %>"
        javascriptsDir:          "<%= llr.app %>"
        fontsDir:                "<%= llr.app %>"
        importPath:              "components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      prod: options: debugInfo: false
      dev:  options: debugInfo: true
      watch:
        debugInfo: false
        watch:     true


    rev:
      dist:
        src: [
          "<%= llr.dist %>/**/*.js"
          "<%= llr.dist %>/**/*.css"
          "<%= llr.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
          "!<%= llr.dist %>/**/opengraph.png"
        ]


    useminPrepare:
      options: dest: "public"
      html: "<%= llr.dist %>/index.html"


    usemin:
      options: assetsDirs: "<%= llr.dist %>"
      html: [ "<%= llr.dist %>/**/*.html" ]
      css:  [ "<%= llr.dist %>/**/*.css" ]


    usebanner:
      options:
        position: "top"
        banner: require "./ascii"
      files:  [ "<%= llr.dist %>/index.html" ]


    ngmin:
      dist:
        expand: true
        cwd:  "<%= llr.tmp %>"
        src:  "**/*.js"
        dest: "<%= llr.tmp %>"


    copy:
      styles_tmp:
        expand: true
        cwd:  "<%= llr.app %>"
        src:  "**/*.css"
        dest: "<%= llr.tmp %>"
      components_dist:
        expand: true
        src:  [ "components/**" ]
        dest: "<%= llr.dist %>"
      app_dist:
        expand: true
        cwd: "<%= llr.app %>"
        dest: "<%= llr.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
        ]


    inject:
      googleAnalytics:
        scriptSrc: "<%= llr.tmp %>/ga.js"
        files:
          "<%= llr.dist %>/index.html": "<%= llr.dist %>/index.html"


    concurrent:
      dist1_dev: [
        "compass:dev"
        "coffee:dev"
        "copy:styles_tmp"
      ]
      dist1: [
        "jade"
        "compass:prod"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist2: [
        "ngmin"
        "autoprefixer"
      ]
      dist3: [
        "copy:app_dist"
        "copy:components_dist"
        "inject:googleAnalytics"
      ]


    ngtemplates:
      llr:
        cwd:  "<%= llr.tmp %>"
        src:  [ "**/*.html", "!index.html" ]
        dest: "<%= llr.dist %>/scripts/templates.js"
        options:
          usemin: "scripts/main.js"



  grunt.registerTask "build", [
    "clean"

    "jade"
    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"

    "ngtemplates"
    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

    "usemin"

    "concurrent:dist3"
    "usebanner"
  ]


  grunt.registerTask "express-keepalive", -> @async()
  grunt.registerTask "express-keepalive", -> @async()


  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run [
        "build"
        "express:prod"
        "express-keepalive"
      ]
    else
      return grunt.task.run [
        "clean"

        "jade"
        "concurrent:dist1_dev"

        "prettify"

        "autoprefixer"
        "useminPrepare"

        "concurrent:dist2"

        "express:dev"

        "watch"
      ]


  grunt.registerTask "default", [
    "build"
  ]

