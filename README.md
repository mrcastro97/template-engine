# Template Engine
This is a basic template engine to deal with front-end demands in the MANAGER application

## How to Test
Just clone this repository, move to the downloaded folder and execute the command bellow:
```
perl test_template.pl
```

## How to Use
First of all you need a template file, we will use this one `template.html`:

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>{{ $page_title }}</title>
  </head>
  <body>
    <table>
      <head>
        <th>#</th>
        <th>Name</th>
        <th>Number</th>
      </head>
      <tbody>
        {{ #forEach $contacts }}
          <tr>
            <td>{{ id }}</td>
            <td>{{ name }}</td>
            <td>{{ number }}</td>
          </tr>
        {{ #end }}
      </tbody>
    </table>
    
  </body>
</html>
```

Than you must create a new template instance, and pass the filepath and parameters  to render your template, like this:

```
use Text::Template;

my $template = Text::Template->new("./template.html", {
  page_title => 'Contact List',
  contacts => [
    {
      id => 1,
      name => "Jhon Doe",
      number => '(77) 99132-2333'
    },
    {
      id => 2,
      name => "Sara Connor",
      number => '(1) 12322-2025'
    }
  ]
});

my $output = $template->render;

print $output;
```

