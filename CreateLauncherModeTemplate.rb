#!/usr/bin/env ruby

# Will generate karabiner-required JSON file to setup triggers holding the 'o' key + any defined below.
# i.e. o+c = VSCode
#
# You can generate json by executing the following command on Terminal, or outputing to file.
# $ ruby ./CreateLauncherModeTemplate.rb
#
# *i.e. --> ruby ./CreateLauncherModeTemplate.rb > ~/.config/karabiner/assets/complex_modifications/o_launcher.json
# Then launch Karabiner and enable rule under complex modifications

# Parameters

def parameters
    {
      :simultaneous_threshold_milliseconds => 500,
      :trigger_key => '0',
    }
  end

  ############################################################

  require 'json'

  def main
    data = {
      'title' => 'O-Launcher',
      'rules' => [
        {
          'description' => 'O-Launcher',
          'manipulators' => [

            generate_launcher_mode('a', [], [{ 'shell_command' => "open -a 'Activity Monitor.app'" }]),
            generate_launcher_mode('b', [], [{ 'shell_command' => "open -a 'Google Chrome.app'" }]),
            generate_launcher_mode('c', [], [{ 'shell_command' => "open -a 'Visual Studio Code.app'" }]),
            generate_launcher_mode('f', [], [{ 'shell_command' => "open -a 'Finder.app'" }]),
            generate_launcher_mode('i', [], [{ 'shell_command' => "open -a 'iTerm.app'" }]),
            generate_launcher_mode('k', [], [{ 'shell_command' => "open -a 'KeePassXC.app'" }]),
            generate_launcher_mode('p', [], [{ 'shell_command' => "open -a 'Opera.app'" }]),
            generate_launcher_mode('s', [], [{ 'shell_command' => "open -a 'Slack.app'" }]),
            generate_launcher_mode('v', [], [{ 'shell_command' => "open -a 'Cisco AnyConnect Secure Mobility Client.app'" }]),

          ].flatten,
        },
      ],
    }

    puts JSON.pretty_generate(data)
  end

  def generate_launcher_mode(from_key_code, mandatory_modifiers, to)
    data = []

    ############################################################

    h = {
      'type' => 'basic',
      'from' => {
        'key_code' => from_key_code,
        'modifiers' => {
          'mandatory' => mandatory_modifiers,
          'optional' => [
            'any',
          ],
        },
      },
      'to' => to,
      'conditions' => [
        {
          'type' => 'variable_if',
          'name' => 'launcher_mode',
          'value' => 1,
        },
      ],
    }

    data << h

    ############################################################

    h = {
      'type' => 'basic',
      'from' => {
        'simultaneous' => [
          {
            'key_code' => parameters[:trigger_key],
          },
          {
            'key_code' => from_key_code,
          },
        ],
        'simultaneous_options' => {
          'key_down_order' => 'strict',
          'key_up_order' => 'strict_inverse',
          'to_after_key_up' => [
            {
              'set_variable' => {
                'name' => 'launcher_mode',
                'value' => 0,
              },
            },
          ],
        },
        'modifiers' => {
          'mandatory' => mandatory_modifiers,
          'optional' => [
            'any',
          ],
        },
      },
      'to' => [
        {
          'set_variable' => {
            'name' => 'launcher_mode',
            'value' => 1,
          },
        },
      ].concat(to),
      'parameters' => {
        'basic.simultaneous_threshold_milliseconds' => parameters[:simultaneous_threshold_milliseconds],
      },
    }

    data << h

    ############################################################

    data
  end

  main