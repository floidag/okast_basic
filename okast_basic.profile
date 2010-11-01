<?php

function okast_basic_profile_details() {
  return array(
    'name' => 'Okast Basic',
    'description' => 'Okast Basic install profile enabling some modules and making some thoughtful configurations.'
  );
}

function okast_basic_profile_tasks(&$task, $url) {
  install_include(okast_basic_profile_modules());
  
  // Set up different default theme (and disable Garland)
  install_default_theme('basic');
  install_disable_theme('garland');
  
  db_query("DELETE FROM {blocks}");
  
  install_admin_theme('rubik');
  
  // Global theme settings
  variable_set('theme_settings', array(
      'toggle_logo' => 1,
      'toggle_name' => 1,
      'toggle_slogan' => 0,
      'toggle_mission' => 0,
      'toggle_node_user_picture' => 0,
      'toggle_comment_user_picture' => 0,
      'toggle_search' => 0,
      'toggle_favicon' => 1,
      'toggle_primary_links' => 1,
      'toggle_secondary_links' => 0,
      'toggle_node_info_page' => 0,
      'toggle_node_info_profile' => 0,
      'default_logo' => 1,
      'logo_path' => '',
      'logo_upload' => '',
      'default_favicon' => 1,
      'favicon_path' => '',
      'favicon_upload' => '',
    )
  );
  
  
  // Types
  // api.drupal.org/api/HEAD/function/hook_node_info.
  $types = array(
    array(
      'type' => 'page',
      'name' => st('Page'),
      'module' => 'node',
      'description' => st("A <em>page</em> is a simple method for creating and displaying information that rarely changes, such as an \"About us\" section of a website. By default, a <em>page</em> entry does not allow visitor comments."),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
      'help' => '',
      'min_word_count' => '',
    ),
  );
  
  foreach ($types as $type) {
     $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
  }
  
  // Comment settings
  $types = node_get_types('names');
  foreach($types as $type => $name) {
    // set order to reverse chronological
    variable_set('comment_default_order_'. $type, 2);
    // display comment form below content
    variable_set('comment_form_location_'. $type, 1);
  }
  
  // Configure user settings. Set user creation to administrator only.
  variable_set('user_register', '0');
  
  // Set site_footer value.
  variable_set('site_footer', st('&copy; Copyright 2010 by Okast. All rights reserved.'));
  
  // Configure user settings. Set user creation to administrator only.
  variable_set('anonymous', 'Guest');
  
  variable_set('node_admin_theme', 1);
  
  variable_set('pathauto_node_page_pattern', '[title-raw]');
  
  // Image API: use GD2 and set quality to 100%
  variable_set('image_jpeg_quality', '100');
  variable_set('imageapi_image_toolkit', 'imageapi_gd');
  variable_set('imageapi_jpeg_quality', '100');
  
  // Admin menu config: left vertical, only admin-create and admin-menu enableda
  variable_set('admin_toolbar', array (
    'layout' => 'vertical',
    'position' => 'nw',
    'behavior' => 'df',
    'blocks' => 
    array (
      'admin-create' => -1,
      'admin-menu' => 1,
    ),
  ));
  
  
  
  // Create Home Page.
  $node = new StdClass();
  $node->type = 'page';
  $node->status = 1;
  $node->promote = 0;
  $node->uid = 1;
  $node->name = 'admin';
  $node->path = 'home';
  $node->title = 'Welcome';
  $node->body = 'Have fun.<ul><li><a href="/admin">admin</a></li></ul>';
  node_save($node);

  variable_set('site_frontpage', 'node/1');
  
  
  // Default full format with tinymce and settings
  variable_set('filter_default_format', '2');
  $tinymceSettings = 'a:20:{s:7:"default";i:1;s:11:"user_choose";i:0;s:11:"show_toggle";i:1;s:5:"theme";s:8:"advanced";s:8:"language";s:2:"en";s:7:"buttons";a:2:{s:7:"default";a:18:{s:4:"bold";i:1;s:6:"italic";i:1;s:9:"underline";i:1;s:13:"strikethrough";i:1;s:11:"justifyleft";i:1;s:13:"justifycenter";i:1;s:12:"justifyright";i:1;s:7:"bullist";i:1;s:7:"numlist";i:1;s:6:"indent";i:1;s:4:"undo";i:1;s:4:"redo";i:1;s:4:"link";i:1;s:6:"unlink";i:1;s:5:"image";i:1;s:3:"sup";i:1;s:3:"sub";i:1;s:10:"blockquote";i:1;}s:10:"xhtmlxtras";a:1:{s:4:"cite";i:1;}}s:11:"toolbar_loc";s:3:"top";s:13:"toolbar_align";s:4:"left";s:8:"path_loc";s:4:"none";s:8:"resizing";i:1;s:11:"verify_html";i:1;s:12:"preformatted";i:0;s:22:"convert_fonts_to_spans";i:1;s:17:"remove_linebreaks";i:1;s:23:"apply_source_formatting";i:0;s:27:"paste_auto_cleanup_on_paste";i:1;s:13:"block_formats";s:8:"h3,h4,h5";s:11:"css_setting";s:5:"theme";s:8:"css_path";s:0:"";s:11:"css_classes";s:0:"";}';
  db_query("INSERT INTO {wysiwyg} (format, editor, settings) VALUES (2, 'tinymce', '%s')", $tinymceSettings);
  
  // Flowplayer
  variable_set('flowplayer3_mediaplayer_file', 'flowplayer-3.2.5.swf');
  variable_set('swftools_flv_display', 'flowplayer3_mediaplayer');
  variable_set('flowplayer3_mediaplayer', 
      array (
        'clip' => 
        array (
          'autoPlay' => 'false',
          'autoBuffering' => 'false',
          'scaling' => 'scale',
          'start' => '',
          'duration' => '',
          'accelerated' => 'false',
          'bufferLength' => '',
          'provider' => '',
          'fadeInSpeed' => '',
          'fadeOutSpeed' => '',
          'linkUrl' => '',
          'linkWindow' => '_blank',
          'live' => 'false',
          'cuePointMultiplier' => '',
        ),
        'controls' => 
        array (
          'backgroundGradient' => 'medium',
          'progressGradient' => 'medium',
          'bufferGradient' => 'none',
          'sliderGradient' => 'none',
          'autoHide' => 'fullscreen',
          'play' => 'true',
          'volume' => 'true',
          'mute' => 'true',
          'time' => 'true',
          'stop' => 'false',
          'playlist' => 'false',
          'fullscreen' => 'true',
          'scrubber' => 'true',
        ),
        'canvas' => 
        array (
          'height' => '375',
          'width' => '500',
          'backgroundImage' => '',
          'backgroundRepeat' => 'repeat',
          'backgroundGradient' => 'low',
          'border' => '',
          'borderRadius' => '',
        ),
      )
    );
  variable_set('flowplayer3_palette', 
      array (
        'backgroundColor' => '#000000',
        'controlbarbackgroundColor' => '#000000',
        'timeColor' => '#ffffff',
        'durationColor' => '#ffffff',
        'progressColor' => '#666666',
        'bufferColor' => '#c4c4c4',
        'sliderColor' => '#ffffff',
        'buttonColor' => '#969696',
        'buttonOverColor' => '#ffffff',
      )
    );
  
  // Create role 'administrator'
  install_add_role('administrator');
  
  // Views
  install_views_ui_import_from_file('profiles/okast_basic/backend_node_lists.view', 'backend_node_lists');
  
  // Run cron for the first time.
  drupal_cron_run();
}


function okast_basic_profile_modules() {
  return array(
    // required core modules
    'block', 'filter', 'node', 'system', 'user',
    // optional core modules
    'dblog', 'help', 'menu', 'path', 'update',
    
    // module dependencies
    'token', 'ctools',
    
    // the big ones
    'views',
    'content', 'nodereference', 'number', 'optionwidgets', 'text', 'userreference',
    
    // contrib modules
    'admin',
    'advanced_help',
    'backup_migrate',
    'better_formats',
    'devel',
    'diff',
    'features',
    'filefield',
    'imageapi', 'imageapi_gd',
    'imagecache', 'imagecache_ui',
    'imagefield',
    'image_fupload', 'image_fupload_imagefield',
    'install_profile_api',
    'jquery_ui',
    'jquery_update',
    'link',
    'login_destination',
    'module_filter',
    'nodeformsettings',
    'pathauto',
    'publishcontent',
    'vertical_tabs',
    'views_ui',
    'vertical_tabs',
    'wysiwyg'
  );
}

function okast_basic_profile_final() {

}



/**
* Implementation of hook_form_alter().
*
* Allows the profile to alter the site-configuration form. This is
* called through custom invocation, so $form_state is not populated.
*/
function okast_basic_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    // Set default for site name field.
    $form['site_information']['site_name']['#default_value'] = 'Okast basic.';
    $form['site_information']['site_mail']['#default_value'] = 'noreply@example.com';
    $form['admin_account']['account']['name']['#default_value'] = 'root';
    $form['admin_account']['account']['mail']['#default_value'] = 'root@example.com';
  }
}