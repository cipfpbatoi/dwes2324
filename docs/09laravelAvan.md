# Laravel Avançat

## Autenticació i Autorització amb Laravel

### 1. Autenticació

#### 1.1 Configuració inicial
Laravel ofereix dos paquets principals per implementar l’autenticació:
  
1. **Laravel Breeze**: Simple i lleuger, ideal per a projectes educatius i senzills.
2. **Laravel Jetstream**: Robust i complet, inclou funcionalitats avançades com equips, autenticació de dos factors i gestió d'API.

**Instal·lació de Laravel Breeze**
```bash
composer require laravel/breeze --dev
php artisan breeze:install
npm install && npm run dev
php artisan migrate
```

Aquestes ordres configuren:

- Rutes per login, registre, restabliment de contrasenya, etc.
- Plantilles Blade predefinides amb Tailwind CSS.

#### 1.2 Recuperació de l'usuari autenticat
Un cop l'usuari ha fet login, podem accedir a les seues dades:
```php
use Illuminate\Support\Facades\Auth;

// Usuari autenticat
$user = Auth::user();

// ID de l'usuari autenticat
$id = Auth::id();
```

També podem obtenir l’usuari des d'una petició injectada al controlador:
```php
public function dashboard(Request $request)
{
    $user = $request->user(); // Equivalent a Auth::user()
}
```

#### 1.3 Protegir rutes amb middleware
El middleware `auth` assegura que només els usuaris autenticats poden accedir a una ruta:
```php
Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware('auth');
```

#### 1.4 Logout
Laravel Breeze inclou logout preconfigurat:
```php
<form method="POST" action="{{ route('logout') }}">
    @csrf
    <button type="submit">Logout</button>
</form>
```

#### 1.5 Restabliment de contrasenya
Per habilitar el restabliment de contrasenya:

1. Configura el correu SMTP al fitxer `.env`.
2. Laravel Breeze genera automàticament els formularis i la lògica necessària.

 
### 2. Autorització

#### 2.1 Rols i permisos
**Afegir un camp `role` a la taula `users`**  
Per implementar rols:
1. Crear una migració:
   ```bash
   php artisan make:migration add_role_to_users_table --table=users
   ```
2. Afegir el camp `role`:
   ```php
   Schema::table('users', function (Blueprint $table) {
       $table->string('role')->default('user'); // Opcions: 'user', 'admin', etc.
   });
   ```
3. Actualitzar el model `User`:
   ```php
   class User extends Authenticatable
   {
       protected $fillable = ['name', 'email', 'password', 'role'];
   }
   ```

**Middleware per a rols**
1. Crear un middleware:
   ```bash
   php artisan make:middleware RoleMiddleware
   ```
2. Definir el rol al middleware:
   ```php
   public function handle($request, Closure $next, $role)
   {
       if (Auth::check() && Auth::user()->role === $role) {
           return $next($request);
       }
       return redirect('/');
   }
   ```
3. Registrar-lo a `Kernel.php`:
   ```php
   protected $routeMiddleware = [
       'role' => \App\Http\Middleware\RoleMiddleware::class,
   ];
   ```
4. Aplicar-lo a una ruta:
   ```php
   Route::get('/admin', function () {
       return view('admin.dashboard');
   })->middleware('role:admin');
   ```


#### Què és un Middleware?

Un **middleware** és una classe que actua com a intermediari entre una sol·licitud HTTP i la seua resposta. En Laravel, els middleware s'utilitzen per executar codi abans o després que una sol·licitud arribe al controlador, permetent així gestionar tasques com:
- Autenticació d'usuaris.
- Validació de permisos o rols.
- Filtratge de dades de la petició.
- Modificació de respostes.

Els middleware són ideals per encapsular lògica comuna que cal aplicar a diverses rutes, com per exemple assegurar que només usuaris autenticats poden accedir a certes àrees de l'aplicació.

Exemple d'ús:
```php
public function handle($request, Closure $next)
{
    if (Auth::check()) {
        return $next($request); // Continua amb la sol·licitud
    }
    return redirect('login'); // Redirigeix si no està autenticat
}
```

Els middleware es registren al fitxer `Kernel.php`, i poden aplicar-se a rutes específiques o a tot l'aplicatiu.

#### 2.2 Policies per a accés granular

**Creació d'una Policy**  

Les policies permeten definir regles d'autorització específiques:

```bash
php artisan make:policy PostPolicy --model=Post
```

Exemple per permetre que un usuari només puga editar els seus posts:
```php
public function update(User $user, Post $post)
{
    return $user->id === $post->user_id;
}
```
Registrar la política a `AuthServiceProvider`:
```php
protected $policies = [
    Post::class => PostPolicy::class,
];
```

Ús de la política en un controlador:
```php
public function edit(Post $post)
{
    $this->authorize('update', $post);
    return view('posts.edit', compact('post'));
}
```

### 3.Utilitzar Form Requests per a Validacions més Complexes

Els **Form Requests** són classes dedicades que encapsulen la lògica de validació d'una sol·licitud HTTP. Aquestes classes permeten organitzar millor el codi, especialment en formularis amb moltes regles de validació.

#### 1. Crear un Form Request
Per crear un **Form Request**, utilitzem l'eina Artisan:
```bash
php artisan make:request MoviePost
```
Això genera una nova classe a la carpeta `app/Http/Requests`. Aquesta classe conté dos mètodes principals:

1. **authorize()**  
   Retorna `true` o `false` segons si l'usuari està autoritzat a fer la sol·licitud. Per defecte, podem retornar `true` per permetre totes les sol·licituds:
    ```php
    public function authorize()
    {
        return true;
    }
    ```

2. **rules()**  
   Retorna un array amb les regles de validació:
    ```php
    public function rules()
    {
        return [
            'title' => 'required|min:3',
            'director' => 'required',
            'year' => 'required|numeric|min:1900',
        ];
    }
    ```

#### 2. Utilitzar el Form Request en un Controlador
En lloc d'especificar les regles de validació directament al controlador, podem injectar el **Form Request** al mètode del controlador:
```php
public function store(MoviePost $request)
{
    // Si arribem aquí, les dades són vàlides.
    // Accedim a les dades validades:
    $validated = $request->validated();

    // Crear una nova pel·lícula
    $movie = new Movie($validated);
    $movie->save();

    return redirect()->route('movies.index');
}
```
El mètode `validated()` retorna només les dades que han passat les regles de validació.

#### 3. Personalitzar Missatges d'Error
Podem personalitzar els missatges d'error sobreescrivint el mètode **messages()** dins del Form Request:
```php
public function messages()
{
    return [
        'title.required' => 'El camp títol és obligatori.',
        'title.min' => 'El camp títol ha de tindre almenys 3 caràcters.',
        'year.required' => 'El camp any és obligatori.',
    ];
}
```

#### 4. Mostrar Errors de Validació a la Vista
Quan es produeixen errors de validació, Laravel redirigeix automàticament a la vista anterior amb la variable global `$errors`, que conté els errors de validació.

Exemple de com mostrar un llistat d'errors al començament del formulari:
```php
@if ($errors->any())
    <ul>
        @foreach($errors->all() as $error)
            <li>{{ $error }}</li>
        @endforeach
    </ul>
@endif
```

Per mostrar errors específics sota un camp:
```php
<div class="form-group">
    <label for="title">Títol:</label>
    <input type="text" name="title" id="title" class="form-control" value="{{ old('title') }}">
    @if ($errors->has('title'))
        <div class="text-danger">{{ $errors->first('title') }}</div>
    @endif
</div>
```


## Ús d'idiomes en Laravel

Laravel proporciona eines senzilles i potents per a la **localització d'aplicacions**, permetent suportar múltiples idiomes. Aquesta funcionalitat és ideal per a desenvolupar aplicacions accessibles a usuaris de diferents regions i llengües.
 
### 1. Configuració Inicial

#### 1.1 Idioma Predeterminat
L'idioma predeterminat s'estableix al fitxer `config/app.php` mitjançant el paràmetre `locale`:
```php
'locale' => 'en', // Idioma predeterminat
```

#### 1.2 Idioma Alternatiu
Es pot definir un idioma "alternatiu" que s'utilitzarà quan no es troben traduccions en l'idioma actiu:
```php
'fallback_locale' => 'en', // Idioma alternatiu
```
 
### 2. Treballant amb Fitxers de Traducció

#### 2.1 Organització dels Fitxers
Els fitxers de traducció es guarden al directori `lang`. Cada idioma té la seua pròpia carpeta, amb fitxers `.php` que contenen arrays clau-valor per a les traduccions:

**Exemple d'estructura:**
```
/lang
    /en
        messages.php
    /es
        messages.php
```

#### 2.2 Crear un Fitxer de Traducció
Un fitxer de traducció típic conté un array de cadenes:
```php
// lang/en/messages.php
return [
    'welcome' => 'Welcome to our application!',
];
```

Per a altres idiomes:
```php
// lang/es/messages.php
return [
    'welcome' => '¡Bienvenido a nuestra aplicación!',
];
```

---

### 3. Ús de Traduccions en el Codi

#### 3.1 Recuperar Traduccions
Utilitza la funció auxiliar `__()` per obtenir les traduccions:
```php
echo __('messages.welcome'); // Welcome to our application!
```

Si la traducció no existeix, es retorna la clau proporcionada:
```php
echo __('messages.unknown'); // messages.unknown
```

#### 3.2 Traduccions amb Paràmetres
És possible definir paràmetres dins de les traduccions utilitzant el símbol `:`, que es substitueix quan es crida a la funció:
```php
// lang/en/messages.php
return [
    'greeting' => 'Hello, :name!',
];
```
```php
echo __('messages.greeting', ['name' => 'John']); // Hello, John!
```

---

### 4. Localització en Temps d'Execució

#### 4.1 Canviar l'Idioma Actiu
Per canviar l'idioma de l'aplicació en temps d'execució, utilitza el mètode `App::setLocale()`:
```php
use Illuminate\Support\Facades\App;

App::setLocale('es'); // Canvia a espanyol
```

Aquesta configuració només afecta la petició actual.
 

### 5. Traduccions amb Fitxers JSON

Laravel permet utilitzar fitxers JSON per a traduccions simples. Aquest enfocament és útil per a aplicacions amb cadenes de traducció úniques i desordenades.

**Exemple de Fitxer JSON:**
```json
// lang/es.json
{
    "I love programming.": "Me encanta programar."
}
```

Per accedir a aquestes cadenes:
```php
echo __('I love programming.');
```

## Enviament de Correus en Laravel

Laravel ofereix una API senzilla i flexible per gestionar l'enviament de correus electrònics. Aquesta funcionalitat és útil per a notificacions, restabliment de contrasenyes i altres comunicacions amb els usuaris.

---

### 1. Configuració Inicial

#### 1.1 Configurar el Servei de Correu
Laravel suporta múltiples serveis d'enviament de correu com SMTP, Mailgun, Postmark, Amazon SES, entre altres. La configuració es defineix al fitxer `.env`:

**Exemple de configuració SMTP per Gmail:**
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=el_teu_email@gmail.com
MAIL_PASSWORD=la_teua_contrasenya
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=el_teu_email@gmail.com
MAIL_FROM_NAME="Nom del Projecte"
```

#### 1.2 Configurar el Fitxer `config/mail.php`
Aquest fitxer conté la configuració global per al sistema de correu. Normalment, no és necessari modificar-lo si es configura correctament el `.env`.

---

### 2. Crear Correus
 
#### 2.1 Crear una Classe de Correu
Les classes de correu es generen amb Artisan:
```bash
php artisan make:mail WelcomeMail
```

Aquest comandament crea una classe al directori `App\Mail`. Aquesta classe és on es defineix el contingut i el disseny del correu.

#### 2.2 Exemple d'una Classe de Correu
```php
namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class WelcomeMail extends Mailable
{
    use Queueable, SerializesModels;

    public $user;

    public function __construct($user)
    {
        $this->user = $user;
    }

    public function build()
    {
        return $this->view('emails.welcome')
                    ->subject('Benvingut a la nostra aplicació');
    }
}
```
 
### 3. Enviar Correus

#### 3.1 Enviar un Correu des d'un Controlador
Utilitza la façana `Mail` per enviar correus:
```php
use App\Mail\WelcomeMail;
use Illuminate\Support\Facades\Mail;

Mail::to('usuari@example.com')->send(new WelcomeMail($user));
```

#### 3.2 Enviar a Múltiples Receptors
Laravel permet enviar correus a múltiples destinataris:
```php
Mail::to(['user1@example.com', 'user2@example.com'])->send(new WelcomeMail($user));
```
 
### 4. Plantilles de Correus

#### 4.1 Crear una Vista per al Correu
Les vistes per a correus es guarden al directori `resources/views/emails`. Exemple de plantilla Blade:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Benvingut</title>
</head>
<body>
    <h1>Hola, {{ $user->name }}</h1>
    <p>Gràcies per registrar-te a la nostra aplicació!</p>
</body>
</html>
```

#### 4.2 Utilitzar Components i Markdown
Laravel permet crear correus amb components de Markdown. Generem un correu amb components:
```bash
php artisan make:mail WelcomeMail --markdown=emails.welcome
```

Aquest comandament crea una plantilla Markdown a `resources/views/emails`.

Exemple de plantilla Markdown:
```markdown
# Benvingut, {{ $user->name }}

Gràcies per unir-te a la nostra aplicació.

@component('mail::button', ['url' => 'https://example.com'])
Visita el nostre lloc web
@endcomponent

Gràcies,<br>
{{ config('app.name') }}
```
 
### 5. Correu en Cua

Per enviar correus de manera asíncrona i millorar el rendiment de l'aplicació, podem utilitzar cues:
```php
Mail::to('usuari@example.com')->queue(new WelcomeMail($user));
```

Assegura't que el sistema de cues estiga configurat al fitxer `.env`:
```env
QUEUE_CONNECTION=database
```

## Sistema de Fitxers en Laravel

Laravel proporciona una API unificada per treballar amb diferents sistemes de fitxers com el sistema local, Amazon S3, FTP, i altres. Aquesta funcionalitat permet gestionar l'emmagatzematge de fitxers d'una manera senzilla i flexible.
 
### 1. Configuració Inicial

#### 1.1 Configurar els Discs d'Emmagatzematge
Els discos d'emmagatzematge es defineixen al fitxer `config/filesystems.php`. Per defecte, Laravel inclou els següents discos:
- **local**: Emmagatzematge en el sistema local.
- **public**: Per fitxers públics accessibles des d'un navegador.
- **s3**: Per emmagatzematge a Amazon S3.

#### 1.2 Configuració del `.env`
Exemple de configuració:
```env
FILESYSTEM_DISK=local
AWS_ACCESS_KEY_ID=el_teu_access_key
AWS_SECRET_ACCESS_KEY=el_teu_secret_key
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=el_teu_bucket
```
 
### 2. Treballar amb el Sistema de Fitxers

#### 2.1 Accedir a un Disc
Utilitza la façana `Storage` per accedir al sistema de fitxers:
```php
use Illuminate\Support\Facades\Storage;

$disk = Storage::disk('local'); // Accedir al disc local
```

Si no especifiques cap disc, Laravel utilitza el disc predeterminat (`FILESYSTEM_DISK` al `.env`).

 
### 3. Operacions Bàsiques amb Fitxers

#### 3.1 Guardar Fitxers
```php
use Illuminate\Support\Facades\Storage;

// Guardar un fitxer amb contingut
Storage::put('documents/file.txt', 'Contingut del fitxer');

// Guardar un fitxer pujat
$file = $request->file('document');
Storage::putFile('uploads', $file);

// Guardar amb un nom personalitzat
Storage::putFileAs('uploads', $file, 'custom_name.txt');
```

#### 3.2 Obtenir Fitxers
```php
// Obtenir el contingut d'un fitxer
$content = Storage::get('documents/file.txt');

// Verificar si un fitxer existeix
if (Storage::exists('documents/file.txt')) {
    // Fitxer existeix
}
```

#### 3.3 Eliminar Fitxers
```php
// Eliminar un fitxer
Storage::delete('documents/file.txt');

// Eliminar múltiples fitxers
Storage::delete(['file1.txt', 'file2.txt']);
```

#### 3.4 Llistar Fitxers
```php
// Llistar tots els fitxers d'un directori
$files = Storage::files('documents');

// Llistar fitxers recursivament
$allFiles = Storage::allFiles('documents');

// Llistar carpetes
$directories = Storage::directories('documents');

// Llistar carpetes recursivament
$allDirectories = Storage::allDirectories('documents');
```
 
### 4. Fitxers Públics

#### 4.1 Publicar Fitxers
Per fer fitxers accessibles públicament, utilitza el disc `public`. Assegura't de crear un enllaç simbòlic per al directori `storage/app/public` al directori `public/storage`:
```bash
php artisan storage:link
```

#### 4.2 Obtenir una URL Pública
```php
$url = Storage::url('documents/file.txt'); // Genera una URL pública
```
 

### 5. Treballar amb Amazon S3

#### 5.1 Configuració
Inclou les credencials d'Amazon S3 al fitxer `.env`:
```env
AWS_ACCESS_KEY_ID=el_teu_access_key
AWS_SECRET_ACCESS_KEY=el_teu_secret_key
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=el_teu_bucket
```

#### 5.2 Exemple
```php
use Illuminate\Support\Facades\Storage;

// Guardar un fitxer a S3
Storage::disk('s3')->put('documents/file.txt', 'Contingut');

// Obtenir una URL
$url = Storage::disk('s3')->url('documents/file.txt');
```

## Gestió de Sessions en Laravel

Laravel ofereix una API senzilla i segura per gestionar sessions d'usuari. Les sessions permeten emmagatzemar dades temporals associades a cada usuari mentre interactua amb l'aplicació.
 
### 1. Tipus de Controladors de Sessió

Laravel suporta diversos tipus de controladors per gestionar sessions. Es defineixen al fitxer `config/session.php` amb el paràmetre `SESSION_DRIVER`.

#### Tipus de Controladors
- **file**: Emmagatzema les dades en fitxers al servidor (predeterminat).
- **cookie**: Desa les dades en cookies xifrades al navegador.
- **database**: Desa les dades en una taula de base de dades.
- **redis**: Utilitza Redis per a una gestió ràpida i distribuïda.
- **array**: Desa les dades en memòria, només per a proves.

**Configuració en el fitxer `.env`:**
```env
SESSION_DRIVER=file
```
 
### 2. Configuració de les Sessions

#### Opcions Clau al Fitxer `config/session.php`
- **lifetime**: Temps d'expiració de la sessió en minuts:
  ```php
  'lifetime' => 120,
  ```
- **expire_on_close**: Expira quan es tanca el navegador:
  ```php
  'expire_on_close' => false,
  ```
- **encrypt**: Si es volen xifrar les dades de sessió:
  ```php
  'encrypt' => false,
  ```

---

### 3. Ús de Sessions

#### 3.1 Afegir Dades a la Sessió
Utilitza el mètode `put` per guardar dades:
```php
session(['key' => 'value']);

// Alternativa amb l'helper:
Session::put('key', 'value');
```

#### 3.2 Obtenir Dades de la Sessió
Utilitza el mètode `get` per recuperar dades:
```php
$value = session('key', 'valor_per_defecte'); // Helper
$value = Session::get('key', 'valor_per_defecte'); // Façana
```

#### 3.3 Eliminar Dades de la Sessió
Elimina una clau específica:
```php
Session::forget('key');
```

Elimina totes les dades de la sessió:
```php
Session::flush();
```
 
### 4. Sessió Flash

Les dades flash només existeixen per a la següent petició HTTP. Són útils per missatges temporals com alertes d'èxit o errors.

#### 4.1 Afegir Dades Flash
```php
Session::flash('status', 'La tasca s'ha completat!');
```

#### 4.2 Recuperar Dades Flash
```php
$value = Session::get('status');
```
 
### 5. Sessió Basada en Base de Dades

#### 5.1 Crear la Taula de Sessió
Per utilitzar el controlador `database`, primer cal crear una taula de base de dades amb el comandament Artisan:
```bash
php artisan session:table
php artisan migrate
```

Això crea una taula anomenada `sessions` amb els camps necessaris.

#### 5.2 Configurar el Driver
Al fitxer `.env`, estableix:
```env
SESSION_DRIVER=database
```

## Testing en Laravel

Laravel proporciona un ecosistema complet per realitzar proves en les aplicacions. Les proves són essencials per assegurar que el codi funciona correctament i evitar regressions.

---

### 1. Tipus de Proves en Laravel

#### 1.1 Proves Unitàries
Les proves unitàries validen la funcionalitat de components individuals del codi, com models o serveis.

#### 1.2 Proves d'Integració
Verifiquen la interacció entre múltiples components de l'aplicació.

#### 1.3 Proves HTTP
Validen rutes, controladors i respostes HTTP.

#### 1.4 Proves de Base de Dades
Asseguren que les dades es processen i emmagatzemen correctament.

#### 1.5 Proves d'Interfície amb Dusk
Simulen la interacció amb el navegador per provar la interfície d'usuari.

---

### 2. Configuració

#### 2.1 Configurar l'Ambient de Proves
Laravel utilitza el fitxer `.env.testing` per definir la configuració de les proves. Per exemple:
```env
APP_ENV=testing
DB_CONNECTION=sqlite
DB_DATABASE=:memory:
```

#### 2.2 Executar Proves
Utilitza PHPUnit per executar les proves:
```bash
php artisan test
```

---

### 3. Proves HTTP

#### 3.1 Crear Proves
Genera una prova amb Artisan:
```bash
php artisan make:test ExampleTest
```

#### 3.2 Exemple de Prova HTTP
```php
namespace Tests\Feature;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    public function test_homepage_loads_correctly()
    {
        $response = $this->get('/');

        $response->assertStatus(200);
        $response->assertSee('Benvingut');
    }
}
```
 
### 4. Proves de Base de Dades

#### 4.1 Migracions en Proves
Utilitza el trait `RefreshDatabase` per executar les migracions abans de cada prova:
```php
use Illuminate\Foundation\Testing\RefreshDatabase;

class ExampleTest extends TestCase
{
    use RefreshDatabase;

    public function test_database_interaction()
    {
        $user = User::factory()->create();

        $this->assertDatabaseHas('users', [
            'email' => $user->email,
        ]);
    }
}
```

#### 4.2 Factories
Utilitza factories per generar dades de prova:
```php
$user = User::factory()->create();
```
 
 

## Laravel Livewire: Introducció

**Laravel Livewire** és un framework que permet construir components d'interfície d'usuari dinàmics sense haver d'escriure JavaScript. Amb Livewire, pots utilitzar PHP per gestionar la lògica del client, mentre que Livewire s'encarrega de la comunicació asincrònica amb el servidor.

### 1. Instal·lació

#### 1.1 Requisits
Laravel Livewire funciona amb aplicacions Laravel. Assegura't de tenir Laravel instal·lat.

#### 1.2 Instal·lar Livewire
Utilitza Composer per instal·lar el paquet:
```bash
composer require livewire/livewire
```

Publica els actius de Livewire:
```bash
php artisan livewire:publish
```

Inclou els scripts de Livewire en les teues vistes Blade:
```html
@livewireStyles
@livewireScripts
```
 
### 2. Crear Components Livewire

#### 2.1 Generar un Component
Utilitza Artisan per crear un component:
```bash
php artisan make:livewire HelloWorld
```

Això genera:
- Un fitxer de classe PHP: `app/Http/Livewire/HelloWorld.php`
- Una plantilla Blade: `resources/views/livewire/hello-world.blade.php`

#### 2.2 Exemple de Component
**Classe del Component:**
```php
namespace App\Http\Livewire;

use Livewire\Component;

class HelloWorld extends Component
{
    public $message = "Hola, món!";

    public function render()
    {
        return view('livewire.hello-world');
    }
}
```

**Plantilla Blade:**
```html
<div>
    <h1>{{ $message }}</h1>
</div>
```

Inclou el component en una vista:
```html
<livewire:hello-world />
```
 
### 3. Interactivitat amb Livewire

#### 3.1 Propietats Dinàmiques
Les propietats de la classe PHP es poden vincular directament als camps d'un formulari HTML:
```php
class Counter extends Component
{
    public $count = 0;

    public function increment()
    {
        $this->count++;
    }

    public function render()
    {
        return view('livewire.counter');
    }
}
```

**Plantilla Blade:**
```html
<div>
    <button wire:click="increment">Incrementar</button>
    <h1>{{ $count }}</h1>
</div>
```

#### 3.2 Validació en Temps Real
Livewire permet validar dades a mesura que l'usuari interactua amb el formulari:
```php
class Form extends Component
{
    public $name;
    public $email;

    protected $rules = [
        'name' => 'required|min:3',
        'email' => 'required|email',
    ];

    public function submit()
    {
        $this->validate();

        // Processar les dades
    }

    public function render()
    {
        return view('livewire.form');
    }
}
```

**Plantilla Blade:**
```html
<div>
    <form wire:submit.prevent="submit">
        <input type="text" wire:model="name">
        @error('name') <span class="text-danger">{{ $message }}</span> @enderror

        <input type="email" wire:model="email">
        @error('email') <span class="text-danger">{{ $message }}</span> @enderror

        <button type="submit">Enviar</button>
    </form>
</div>
```
 
### 4. Avantatges de Livewire
- **Simplicitat**: Evita la necessitat de gestionar JavaScript per funcionalitats comunes.
- **Reactivitat**: Actualitza la interfície automàticament en resposta a canvis de dades.
- **Integració**: Es combina perfectament amb Blade i Laravel.


## Exercici Pràctic: Guia d'Equips de Futbol Femení amb Base de Dades

L'objectiu d'aquest exercici és estendre la Guia d'Equips de Futbol Femení amb les funcionalitats tractades en este tema. 

### Pas 1: Configurar l'autenticació amb Laravel Breeze
1. Copia el fitxer app.blade.php de la carpeta resources/views/layouts a equips.blade.php.
2. Guarda les rutes de la Guia d'Equips de Futbol Femení en algun fitxer per utilitzar després.  
3. Instal·la Laravel Breeze:

```bash
composer require laravel/breeze --dev
php artisan breeze:install
npm install && npm run dev
php artisan migrate
```
 
 
### Pas 2: Afegir els rols al sistema

#### Migració per al camp `role` als usuaris
 
1. Crea una nova migració per afegir el camp `role` a usuaris:
   ```bash
   php artisan make:migration add_role_to_users_table --table=users
   ```
   Afegeix el camp:
   ```php
   Schema::table('users', function (Blueprint $table) {
       $table->string('role')->default('arbitre');
   });
   ```
   Aplica la migració:
   ```bash
   php artisan migrate
   ```

#### Crea el seeders d'usuaris i crea un usuari administrador
 
  ```php
  User::create([
      'name' => 'Admin',
      'email' => 'admin@example.com',
      'password' => Hash::make('password'),
      'role' => 'administrador',
  ]);
  ```
 
### Pas 3: Middleware per a permisos de rol i manager

#### Crear Middleware per a gestionar els rols
1. Genera el middleware:
   ```bash
   php artisan make:middleware RoleMiddleware
   ```
2. Defineix el control dels rols:
   ```php
   public function handle($request, Closure $next, $role)
   {
       if (auth()->user()->role !== $role) {
           return redirect('/')->with('error', 'No tens permís per accedir a aquesta pàgina.');
       }
       return $next($request);
   }
   ```
 
#### Aplicar Middleware a rutes
- Protegeix les rutes per tal que els equips,estadis soles puguen modificar-los els administradors:
  ```php
    Route::middleware(['auth', RoleMiddleware::class.':administrador' ])->group(function (){
        Route::resource('/equips', EquipController::class)->except(['index', 'show']);
        Route::resource('/estadis', EstadisController::class)->except(['index', 'show']);
    });
    Route::resource('/equips', EquipController::class)->only(['index', 'show']);
    Route::resource('/estadis', EstadisController::class)->only(['index', 'show']);

  ```
 

### Pas 4: Associar managers a equips

#### Migració per a l’associació entre usuaris i equips
1. Crea una migració nova:
   ```bash
   php artisan make:migration add_team_id_to_users_table --table=users
   ```
2. Afegeix el camp `team_id`:
   ```php
   Schema::table('users', function (Blueprint $table) {
       $table->unsignedBigInteger('equip_id')->nullable();
       $table->foreign('equip_id')->references('id')->on('equips')->onDelete('set null');
   });
   ```
3. Aplica la migració:
   ```bash
   php artisan migrate
   ```

#### Assignar equips als managers
- Crea un manager per equip i assigna-li  :
  ```php
  foreach (Equip::all() as $equip){
            User::create([
                'name' => 'Manager  '.$equip->nom,
                'email' => $equip->nom.'@manager.com',
                'password' => Hash::make('1234'),
                'role' => 'manager',
                'equip_id' => $equip->id,
            ]);
        }
  ```

### Relació entre models
- Defineix la relació al model `User`:
  ```php
  public function equip()
  {
      return $this->belongsTo(Equip::class );
  }
  ```
- Defineix la relació inversa al model `Equip`:
  ```php
  public function manager()
  {
      return $this->hasOne(User::class );
  }
  ```
  
 
### Pas 5: Adaptar les vistes al component layout de Breeze

1. Modificar equips.blade.php per a utilitzar el layout de Breeze.

```php
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            @yield('title','Guia de futbol femení')
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    @yield('content')
                </div>
            </div>
        </div>
    </div>
    <footer>
        <p>&copy; 2024 Guia de Futbol Femení</p>
    </footer>
</x-app-layout>
```

2. Modificar la vista de l'equip per a utilitzar el layout de Breeze.

```php
@extends('layouts.equips')
```

3. Modificar el layout de Breeze per a incloure el menú de navegació .

En navigation.blade.php:
```php
    ...
    <!-- Navigation Links -->
    <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
        <x-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
            {{ __('Dashboard') }}
        </x-nav-link>
    </div>
    @include('partials.menu')
    ...
```

4. En partials/menu.blade.php:
```php
    ...
    <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
        <x-nav-link :href="route('equips.index')" :active="request()->routeIs('dashboard')">
            {{ __('Guia Equips') }}
        </x-nav-link>
    </div>
    <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
        <x-nav-link :href="route('estadis.index')" :active="request()->routeIs('dashboard')">
            {{ __('Estadis') }}
        </x-nav-link>
    </div>
    ...
```

### Pas 6: El manager soles puga editar el seu equip

#### 1. Crear la Política
Executa el següent comandament per generar la política associada al model `Equip`:
```bash
php artisan make:policy EquipPolicy --model=Equip
```
 
#### 2. Definir la Lògica a la Política
Edita el fitxer generat `app/Policies/EquipPolicy.php` i afegeix les regles de permisos.

 
```php
namespace App\Policies;

use App\Models\User;
use App\Models\Equip;

class EquipPolicy
{
    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        // Només els administradors poden crear equips
        return $user->role === 'administrador';
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Equip $equip)
    {
        // Permetre si l'usuari és un administrador o un manager i està assignat a aquest equip
        return $user->role === 'administrador' || ($user->role === 'manager' && $user->equip_id === $equip->id);
    }

    /**
     * Determina si l'usuari pot eliminar l'equip.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Equip $equip
     * @return bool
     */
    public function delete(User $user, Equip $equip)
    {
        // Només els administradors poden eliminar equips
        return $user->role === 'administrador';
    }
}
```

 
#### 3. Utilitzar la Política al Controlador
Al controlador `EquipController`, utilitza el mètode `authorize` per aplicar la política abans de permetre accions.
 
```php
class EquipController extends Controller
{

    use AuthorizesRequests;

    public function index() {
        $equips = Equip::all();
        return view('equips.index', compact('equips'));
    }

    public function show(Equip $equip) {
        return view('equips.show', compact('equip'));
    }

    public function create() {
        $this->authorize('create');
        $estadis = Estadi::all();
        return view('equips.create',compact('estadis'));
    }

    public function edit(Equip $equip) {
        $this->authorize('update', $equip);
        $estadis = Estadi::all();
        return view('equips.edit', compact('equip','estadis'));
    }


    public function store(Request $request)
    {
        $this->authorize('create');
        $validated = $request->validate([
            'nom' => 'required|unique:equips',
            'titols' => 'integer|min:0',
            'estadi_id' => 'required|exists:estadis,id',
            'escut' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Validació del fitxer
        ]);

        if ($request->hasFile('escut')) {
            $path = $request->file('escut')->store('escuts', 'public');
            $validated['escut'] = $path;
        }

        Equip::create($validated);

        return redirect()->route('equips.index')->with('success', 'Equip creat correctament!');
    }


    public function update(Request $request, Equip $equip)
    {
        $this->authorize('update', $equip);
        $validated = $request->validate([
            'nom' => 'required|unique:equips,nom,' . $equip->id,
            'titols' => 'integer|min:0',
            'estadi_id' => 'required|exists:estadis,id',
            'escut' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);


        if ($request->hasFile('escut')) {
            if ($equip->escut) {
                Storage::disk('public')->delete($equip->escut); // Esborra l'escut antic
            }
            $path = $request->file('escut')->store('escuts', 'public');
            $validated['escut'] = $path;
        }

        $equip->update($validated);

        return redirect()->route('equips.index')->with('success', 'Equip actualitzat correctament!');
    }

    public function destroy(Equip $equip)
    {
        $this->authorize('delete', $equip);
        if ($equip->escut) {
            Storage::disk('public')->delete($equip->escut);
        }
        $equip->delete();
        return redirect()->route('equips.index')->with('success', 'Equip esborrat correctament!');
    }


}
```
  

#### 4. Utilitzar la Política a les Vistes
A les vistes Blade, pots utilitzar les directives `@can` per verificar els permisos.

 
```blade
@can('update', $equip)
    <a href="{{ route('equips.edit', $equip->id) }}" class="text-yellow-600 hover:underline">Editar</a>
@endcan
```

### Pas 7. Afegir FormRequest per a la validació

####  1. Generar el Form Request

Executa el següent comandament per crear un Form Request:

```bash
php artisan make:request StoreEquipRequest
php artisan make:request UpdateEquipRequest
```

Aquest comandament crearà una classe `StoreEquipRequest` i altra `UpdateEquipRequest  al directori `app/Http/Requests`.

---

####  2. Definir les regles de validació

Obre el fitxer `StoreEquipRequest.php` i defineix les regles de validació al mètode `rules`.

##### Exemple de validació:
```php
namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreEquipRequest extends FormRequest
{
    /**
     * Determina si l'usuari està autoritzat a fer aquesta petició.
     *
     * @return bool
     */
    public function authorize(): bool
    {
         return $this->user()->can('create', Equip::class);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'nom' => 'required|unique:equips',
            'titols' => 'integer|min:0',
            'estadi_id' => 'required|exists:estadis,id',
            'escut' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Validació del fitxer
        ];
    }
    
    public function messages()
    {
        return [
            'nom.required' => 'El camp "Nom" és obligatori.',
            'nom.unique' => 'Aquest nom ja està en ús. Si us plau, tria un altre.',
            'titols.integer' => 'El camp "Títols" ha de ser un número enter.',
            'titols.min' => 'El nombre de títols no pot ser inferior a zero.',
            'estadi_id.required' => 'El camp "Estadi" és obligatori.',
            'estadi_id.exists' => 'L\'estadi seleccionat no és vàlid.',
            'escut.image' => 'El camp "Escut" ha de ser una imatge.',
            'escut.mimes' => 'El camp "Escut" només accepta formats: jpeg, png, jpg.',
            'escut.max' => 'La mida de l\'escut no pot superar els 2 MB.',
        ];
    }
}
```
 
#### 3. Modificar el Controlador per Utilitzar el Form Request

Substitueix la injecció de `Request` pel nou `StoreEquipRequest` al mètode `store` del controlador `EquipController`.

##### Exemple:
```php
use App\Http\Requests\StoreEquipRequest;

public function store(StoreEquipRequest $request)
{
     
    $validated = $request->validated(); // Obté les dades validades

    if ($request->hasFile('escut')) {
        $path = $request->file('escut')->store('escuts', 'public');
        $validated['escut'] = $path;
    }

    Equip::create($validated);

    return redirect()->route('equips.index')->with('success', 'Equip creat correctament!');
}
```
 
#### 4. Fes el mateix per al Mètode `update`

 
Defineix les regles al mètode `rules`, incloent l'excepció per al camp únic (en aquest cas, el `nom`):

  
```php
use App\Http\Requests\StoreEquipRequest;

public function authorize()
{
    $equip = $this->route('equip'); // Obté l'equip de la ruta
    return $this->user()->can('update', $equip);
}

public function rules()
{
    $equipId = $this->route('equip')->id; // Obté l'ID de l'equip actual

    return [
        'nom' => 'required|unique:equips,nom,' . $equipId,
        'titols' => 'integer|min:0',
        'estadi_id' => 'required|exists:estadis,id',
        'escut' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
    ];
} 
```
## Pas 8. Idiomes al projecte 

#### 1. Publicar els Fitxers de Llenguatge

Per defecte, Laravel no inclou el directori `lang`. Per personalitzar els fitxers de llenguatge o crear-ne de nous, executa:

```bash
php artisan lang:publish
```

Aquesta comanda crearà el directori `lang` i publicarà els fitxers de llenguatge predeterminats de Laravel.

 

#### 2. Configurar l'Idioma Predeterminat

Al fitxer `.env`, ajusta l'opcions `locale` per establir l'idioma predeterminat:

```php
APP_LOCALE=ca
APP_FALLBACK_LOCALE=en
```

 
 
#### 3. Definir les Traduccions

Les cadenes de traducció es poden emmagatzemar en fitxers PHP o JSON dins del directori `lang`.

##### Utilitzant Fitxers PHP

Crea subdirectoris per a cada idioma dins de `lang` i afegeix els fitxers de traducció corresponents. Per exemple:

```
/lang
     ca.json
     es.json 
     en.json
```

Cada fitxer ha de retornar un array de cadenes traduïdes:

```json
 {
  "Creació d'Equip": "Creació d'Equip",
  "Guia d'Equips": "Guia d'Equips",
  "Modificació d'Equip": "Modificació d'Equip",
  "Escut actual": "Escut actual",
  "Escut": "Escut",
  "Estadi": "Estadi",
  "Nom": "Nom",
  "Títols": "Títols",
  "Guardar": "Guardar",
  "Actualitzar": "Actualitzar",
  "Esborrar": "Esborrar",
  "Crear Equip": "Crear Equip"  
}
```
```json
{
  "Creació d'Equip": "Creación de Equipo",
  "Guia d'Equips": "Guía de Equipos",
  "Modificació d'Equip": "Modificación de Equipo",
  "Escut actual": "Escudo actual",
  "Escut": "Escudo",
  "Estadi": "Estadio",
  "Nom": "Nombre",
  "Títols": "Títulos",
  "Guardar": "Guardar",
  "Actualitzar": "Actualizar",
  "Esborrar": "Borrar",
  "Crear Equip": "Crear Equipo"
} 
```
```json
{
  "Creació d'Equip": "Team Creation",
  "Guia d'Equips": "Team Guide",
  "Modificació d'Equip": "Team Modification",
  "Escut actual": "Current Shield",
  "Escut": "Shield",
  "Estadi": "Stadium",
  "Nom": "Name",
  "Títols": "Titles",
  "Guardar": "Save",
  "Actualitzar": "Update",
  "Esborrar": "Delete",
  "Crear Equip": "Create Team"
}
```
 
 
#### 4. Recuperar Cadenes de Traducció

Utilitza la funció `__` per obtenir les cadenes traduïdes:

```php
 
 @extends('layouts.equips')

@section('title', __("Creació d'Equips"))

@section('content')
    <form action="{{ route('equips.store') }}" method="POST" enctype="multipart/form-data" class="bg-white p-6 rounded-lg shadow-md max-w-md mx-auto">
        @csrf
        <div class="mb-4">
            <label for="nom" class="block text-sm font-medium text-gray-700 mb-1">{{ __('Nom')}}:</label>
            <input type="text" name="nom" id="nom" required
                   class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <div class="mb-4">
            <label for="titols" class="block text-sm font-medium text-gray-700 mb-1">{{__('Títols')}}:</label>
            <input type="number" name="titols" id="titols" required
                   class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <div class="mb-4">
            <label for="estadi_id" class="block text-sm font-medium text-gray-700 mb-1">{{__('Estadi')}}:</label>
            <select name="estadi_id" id="estadi_id" required
                    class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500">
                @foreach ($estadis as $estadi)
                    <option value="{{ $estadi->id }}">{{ $estadi->nom }}</option>
                @endforeach
            </select>
        </div>

        <div class="mb-4">
            <label for="escut" class="block text-sm font-medium text-gray-700 mb-1">{{__('Escut')}}:</label>
            <input type="file" name="escut" id="escut"
                   class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <button type="submit"
                class="w-full bg-blue-500 text-white font-medium py-2 px-4 rounded-lg shadow hover:bg-blue-600 focus:ring focus:ring-blue-300">
            {{__('Crear Equip')}}
        </button>
    </form>
@endsection

```
  
#### 5. Canviar l'Idioma Dinàmicament

Per canviar l'idioma durant l'execució, utilitza el mètode `setLocale`:

```php
App::setLocale('es');
```

Per facilitar als usuaris la selecció de l'idioma, pots crear rutes o enllaços que estableixin l'idioma desitjat.

---

#### 7. Traduir Missatges de Validació

Els missatges de validació es poden personalitzar als fitxers de llenguatge corresponents. Per exemple, al fitxer `resources/lang/ca/validation.php`:

```php
<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Missatges de validació
    |--------------------------------------------------------------------------
    |
    | Les següents línies contenen els missatges d'error per a les diferents
    | regles de validació. Pots ajustar aquests missatges segons les
    | necessitats de la teva aplicació.
    |
    */

    'accepted' => 'El camp :attribute ha de ser acceptat.',
    'active_url' => 'El camp :attribute no és una URL vàlida.',
    'after' => 'El camp :attribute ha de ser una data posterior a :date.',
    'after_or_equal' => 'El camp :attribute ha de ser una data igual o posterior a :date.',
    'alpha' => 'El camp :attribute només pot contenir lletres.',
    'alpha_dash' => 'El camp :attribute només pot contenir lletres, números, guions i guions baixos.',
    'alpha_num' => 'El camp :attribute només pot contenir lletres i números.',
    'array' => 'El camp :attribute ha de ser un array.',
    'before' => 'El camp :attribute ha de ser una data anterior a :date.',
    'before_or_equal' => 'El camp :attribute ha de ser una data igual o anterior a :date.',
    'between' => [
        'numeric' => 'El camp :attribute ha d\'estar entre :min i :max.',
        'file' => 'El camp :attribute ha de tenir entre :min i :max kilobytes.',
        'string' => 'El camp :attribute ha de tenir entre :min i :max caràcters.',
        'array' => 'El camp :attribute ha de tenir entre :min i :max elements.',
    ],
    'boolean' => 'El camp :attribute ha de ser verdader o fals.',
    'confirmed' => 'La confirmació del camp :attribute no coincideix.',
    'date' => 'El camp :attribute no és una data vàlida.',
    'date_format' => 'El camp :attribute no coincideix amb el format :format.',
    'different' => 'Els camps :attribute i :other han de ser diferents.',
    'digits' => 'El camp :attribute ha de tenir :digits dígits.',
    'digits_between' => 'El camp :attribute ha de tenir entre :min i :max dígits.',
    'dimensions' => 'El camp :attribute té dimensions d\'imatge no vàlides.',
    'distinct' => 'El camp :attribute té un valor duplicat.',
    'email' => 'El camp :attribute ha de ser una adreça de correu electrònic vàlida.',
    'exists' => 'El camp :attribute seleccionat no és vàlid.',
    'file' => 'El camp :attribute ha de ser un fitxer.',
    'filled' => 'El camp :attribute ha de tenir un valor.',
    'gt' => [
        'numeric' => 'El camp :attribute ha de ser més gran que :value.',
        'file' => 'El camp :attribute ha de tenir més de :value kilobytes.',
        'string' => 'El camp :attribute ha de tenir més de :value caràcters.',
        'array' => 'El camp :attribute ha de tenir més de :value elements.',
    ],
    'gte' => [
        'numeric' => 'El camp :attribute ha de ser més gran o igual a :value.',
        'file' => 'El camp :attribute ha de tenir com a mínim :value kilobytes.',
        'string' => 'El camp :attribute ha de tenir com a mínim :value caràcters.',
        'array' => 'El camp :attribute ha de tenir com a mínim :value elements.',
    ],
    'image' => 'El camp :attribute ha de ser una imatge.',
    'in' => 'El camp :attribute seleccionat no és vàlid.',
    'in_array' => 'El camp :attribute no existeix a :other.',
    'integer' => 'El camp :attribute ha de ser un nombre enter.',
    'ip' => 'El camp :attribute ha de ser una adreça IP vàlida.',
    'ipv4' => 'El camp :attribute ha de ser una adreça IPv4 vàlida.',
    'ipv6' => 'El camp :attribute ha de ser una adreça IPv6 vàlida.',
    'json' => 'El camp :attribute ha de ser una cadena JSON vàlida.',
    'lt' => [
        'numeric' => 'El camp :attribute ha de ser més petit que :value.',
        'file' => 'El camp :attribute ha de tenir menys de :value kilobytes.',
        'string' => 'El camp :attribute ha de tenir menys de :value caràcters.',
        'array' => 'El camp :attribute ha de tenir menys de :value elements.',
    ],
    'lte' => [
        'numeric' => 'El camp :attribute ha de ser més petit o igual a :value.',
        'file' => 'El camp :attribute ha de tenir com a màxim :value kilobytes.',
        'string' => 'El camp :attribute ha de tenir com a màxim :value caràcters.',
        'array' => 'El camp :attribute no ha de tenir més de :value elements.',
    ],
    'max' => [
        'numeric' => 'El camp :attribute no pot ser més gran que :max.',
        'file' => 'El camp :attribute no pot tenir més de :max kilobytes.',
        'string' => 'El camp :attribute no pot tenir més de :max caràcters.',
        'array' => 'El camp :attribute no pot tenir més de :max elements.',
    ],
    'mimes' => 'El camp :attribute ha de ser un fitxer de tipus: :values.',
    'mimetypes' => 'El camp :attribute ha de ser un fitxer de tipus: :values.',
    'min' => [
        'numeric' => 'El camp :attribute ha de ser com a mínim :min.',
        'file' => 'El camp :attribute ha de tenir com a mínim :min kilobytes.',
        'string' => 'El camp :attribute ha de tenir com a mínim :min caràcters.',
        'array' => 'El camp :attribute ha de tenir com a mínim :min elements.',
    ],
    'not_in' => 'El camp :attribute seleccionat no és vàlid.',
    'not_regex' => 'El format del camp :attribute no és vàlid.',
    'numeric' => 'El camp :attribute ha de ser un nombre.',
    'present' => 'El camp :attribute ha de ser present.',
    'regex' => 'El format del camp :attribute no és vàlid.',
    'required' => 'El camp :attribute és obligatori.',
    'required_if' => 'El camp :attribute és obligatori quan :other és :value.',
    'required_unless' => 'El camp :attribute és obligatori excepte si :other és a :values.',
    'required_with' => 'El camp :attribute és obligatori quan :values és present.',
    'required_with_all' => 'El camp :attribute és obligatori quan :values són presents.',
    'required_without' => 'El camp :attribute és obligatori quan :values no és present.',
    'required_without_all' => 'El camp :attribute és obligatori quan cap de :values són presents.',
    'same' => 'Els camps :attribute i :other han de coincidir.',
    'size' => [
        'numeric' => 'El camp :attribute ha de tenir la mida :size.',
        'file' => 'El camp :attribute ha de tenir :size kilobytes.',
        'string' => 'El camp :attribute ha de tenir :size caràcters.',
        'array' => 'El camp :attribute ha de contenir :size elements.',
    ],
    'starts_with' => 'El camp :attribute ha de començar amb un dels valors següents: :values.',
    'string' => 'El camp :attribute ha de ser una cadena de text.',
    'timezone' => 'El camp :attribute ha de ser una zona horària vàlida.',
    'unique' => 'El camp :attribute ja està en ús.',
    'uploaded' => 'El camp :attribute ha fallat en pujar.',
    'url' => 'El format del camp :attribute no és vàlid.',
    'uuid' => 'El camp :attribute ha de ser un identificador UUID vàlid.',

    /*
    |--------------------------------------------------------------------------
    | Missatges personalitzats per a atributs
    |--------------------------------------------------------------------------
    |
    | Pots utilitzar aquesta secció per personalitzar els noms dels atributs.
    |
    */

    'attributes' => [],
];

```

Això assegura que els missatges de validació es mostren en l'idioma seleccionat.

### Pas 9. Crear proves

1. Crea un fitxer de proves per al CRUD d'equips:
```bash
php artisan make:test EquipCRUDTest
```

2. Modifica el fitxer de proves `tests/Feature/EquipCRUDTest.php`:
```php
namespace Tests\Feature;

use App\Models\Estadi;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Equip;

class EquipCrudTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function es_pot_crear_un_equip_correctament()
    {
        // Actuar: Crear un equip
        $estadi = Estadi::create([
            'nom' => 'Camp Nou',
            'ciutat' => 'Barcelona',
            'capacitat' => 99354,
        ]);
        $equip = Equip::create([
            'nom' => 'FC Barcelona',
             'titols' =>30,
             'estadi_id' => 1,
        ]);

        // Comprovar que l’equip es guarda a la base de dades
        $this->assertDatabaseHas('equips', [
            'nom' => 'FC Barcelona',
            'titols' => 30,
            'estadi_id' => 1,
        ]);
    }

    public function es_poden_llistar_els_equips()
    {
        // Arrange: Crear equips
        Equip::factory()->create(['nom' => 'FC Barcelona']);
        Equip::factory()->create(['nom' => 'Real Madrid']);

        // Actuar: Obtenir la llista d’equips
        $equips = Equip::all();

        // Comprovar que la llista conté els equips creats
        $this->assertCount(2, $equips);
        $this->assertEquals('FC Barcelona', $equips[0]->nom);
        $this->assertEquals('Real Madrid', $equips[1]->nom);
    }

    public function es_pot_actualitzar_un_equip()
    {
        // Arrange: Crear un equip
        $equip = Equip::create([
            'nom' => 'FC Barcelona',
            'ciutat' => 'Barcelona',
        ]);

        // Actuar: Actualitzar l’equip
        $equip->update([
            'nom' => 'Barça',
            'ciutat' => 'Catalunya',
        ]);

        // Comprovar que els canvis es reflecteixen a la base de dades
        $this->assertDatabaseHas('equips', [
            'nom' => 'Barça',
            'ciutat' => 'Catalunya',
        ]);
    }

    public function es_pot_esborrar_un_equip()
    {
        // Arrange: Crear un equip
        $equip = Equip::create([
            'nom' => 'FC Barcelona',
            'ciutat' => 'Barcelona',
        ]);

        // Actuar: Esborrar l’equip
        $equip->delete();

        // Comprovar que l’equip ja no existeix a la base de dades
        $this->assertDatabaseMissing('equips', [
            'nom' => 'FC Barcelona',
            'ciutat' => 'Barcelona',
        ]);
    }

    public function no_es_pot_crear_un_equip_sense_nom()
    {
        $this->expectException(\Illuminate\Database\QueryException::class);

        // Intentar crear un equip sense nom
        Equip::create([
            'ciutat' => 'Barcelona',
        ]);
    }
}
```
3. Copia el .env en .env.testing i modifica'l per a executar les proves en una BBDD de testing

```bash
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=testing
DB_USERNAME=sail
DB_PASSWORD=password
```

4. Executa les proves:
```bash
php artisan test
```

### Pas 10. Generar un correu electrònic amb la jornada actual (partits programats) i enviar-lo als managers dels equips.

#### **1. Crear una Comanda Artisan**
```bash
php artisan make:command EnviarJornadaManagers
```

Al fitxer `app/Console/Commands/EnviarJornadaManagers.php`:

```php
namespace App\Console\Commands;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;
use App\Models\Partit;
use App\Mail\JornadaMail;

class EnviarJornadaManagers extends Command
{
    protected $signature = 'jornada:enviar';
    protected $description = 'Envia la jornada actual als managers';

    public function handle()
    {
        $partit = Partit::whereDate('data', '>', Carbon::now()) // Filtra partits posteriors a avui
            ->orderBy('data', 'asc') // Ordena per la data més propera
            ->first();
        $partits = Partit::with(['equipLocal', 'equipVisitant'])->where('jornada',$partit->jornada)->get();

        // Lògica per obtenir els correus dels managers
        $managers = User::where('role','manager')->get();


        foreach ($managers as $manager) {
            Mail::to($manager->email)->send(new JornadaMail($partits));
            $this->info($manager->name . ' ha rebut la jornada.');

        }

        $this->info('La jornada s\'ha enviat correctament als managers.');
    }
}
 
#### **2. Crear el Mail**
```bash
php artisan make:mail JornadaMail --markdown=emails.jornada
```

Al fitxer `app/Mail/JornadaMail.php`:

```php
namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Queue\SerializesModels;

class JornadaMail extends Mailable
{
    use Queueable, SerializesModels;

    public $partits;

    public function __construct($partits)
    {
        $this->partits = $partits;
    }



    public function content(): Content
    {
        return new Content(
            markdown: 'emails.jornada',
            with: [
                'partits' => $this->partits,
            ],
        );
    }
}

```

 
#### **3. Crear la Vista del Correu**
Al fitxer `resources/views/emails/jornada.blade.php`:

```markdown
<x-mail::message>
    # Jornada {{ $partits->first()->jornada }}

    ## Partits Programats:
    @foreach($partits as $partit)
        - **{{ $partit->equipLocal->nom }}** vs **{{ $partit->equipVisitant->nom }}** ({{ $partit->data }})
    @endforeach

    Gràcies,
    **{{ config('app.name') }}**
</x-mail::message>
```
 
#### **4. Efectuar l'Enviament**
Pots enviar els correus manualment executant la comanda:

```bash
php artisan jornada:enviar
``` 

Pots programar la comanda al `Kernel.php`:

```php
protected function schedule(Schedule $schedule)
{
    $schedule->command('jornada:enviar')->weeklyOn(1, '8:00');
}
```


### Pas 11. Crear un component livewire per a mostrar un històric de partits

1. Instal·la Livewire:
```bash
composer require livewire/livewire
php artisan livewire:publish
```

2. Afegeix els scripts de Livewire a la plantilla Blade:

```html
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles
</head>
<body class="font-sans antialiased">
<div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    @include('layouts.navigation')

    <!-- Page Heading -->
    @isset($header)
    <header class="bg-white dark:bg-gray-800 shadow">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
            {{ $header }}
        </div>
    </header>
    @endisset

    <!-- Page Content -->
    <main>
        {{ $slot }}
    </main>
</div>
@livewireScripts
</body>
</html>
```
3. Genera el component Livewire:
```bash
 php artisan make:livewire HistorialPartits
```

4. Modifica el component Livewire `app/Livewire/HistorialPartits.php`:
```php
namespace App\Livewire;

use App\Models\Partit;
use Livewire\Component;

class HistorialPartits extends Component
{
    public $partits;
    public $equip = '';
    public $data = '';

    public function mount()
    {
        $this->partits = Partit::with(['equipLocal', 'equipVisitant', 'estadi', 'arbitre'])->get();
    }


    public function filtrar()
    {
        $this->partits = Partit::with(['equipLocal', 'equipVisitant', 'estadi', 'arbitre'])
            ->when($this->equip, function ($query) {
                $query->whereHas('equipLocal', fn($q) => $q->where('nom', 'like', "%{$this->equip}%"))
                    ->orWhereHas('equipVisitant', fn($q) => $q->where('nom', 'like', "%{$this->equip}%"));
            })
            ->when($this->data, function ($query) {
                $query->whereDate('data', $this->data);
            })
            ->get();
    }

    public function render()
    {
        return view('livewire.historial-partits', ['partits' => $this->partits]);
    }
}
```
5. Modifica la vista del component Livewire `resources/views/livewire/historial-partits.blade.php`:
```php
<div>
    <div class="flex space-x-4">
        <input wire:model="equip" type="text" placeholder="Cerca equip" class="border px-4 py-2">
        <input wire:model="data" type="date" class="border px-4 py-2">
        <button wire:click="filtrar" class="bg-blue-500 text-white px-4 py-2">Filtrar</button>
    </div>

    <table class="table-auto w-full mt-4">
        <thead>
        <tr>
            <th>Data</th>
            <th>Equip Local</th>
            <th>Equip Visitant</th>
            <th>Resultat</th>
            <th>Estadi</th>
            <th>Àrbitre</th>
        </tr>
        </thead>
        <tbody>
        @foreach($partits as $partit)
            <tr>
                <td>{{ $partit->data }}</td>
                <td>{{ $partit->equipLocal->nom }}</td>
                <td>{{ $partit->equipVisitant->nom }}</td>
                <td>{{ $partit->resultat }}</td>
                <td>{{ $partit->estadi->nom }}</td>
                <td>{{ $partit->arbitre->name }}</td>
            </tr>
        @endforeach
        </tbody>
    </table>
</div>
```
6. Crea la vista `resources/views/partits/historic.blade.php`:
```php
@extends('layouts.futbolFemeni')

@section('title', __('Històric de partits' ))

@section('content')

    <!-- Afegim el component Livewire aquí -->
    <div class="mt-8">
        @livewire('historial-partits')
    </div>
@endsection
```
7. Modifica la ruta `routes/web.php`:
```php
Route::get('/historic', [PartitController::class, 'historic'])->name('partits.historic');

```
8. Modifica el controlador `app/Http/Controllers/PartitController.php`:
```php
public function historic()
{
    return view('partits.historic');
}
```
9. Afegix entrada en el menú `resources/views/layouts/navigation.blade.php`:
```php
<div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
    <x-nav-link :href="route('partits.historic')" :active="request()->routeIs('partits.historic')">
        {{ __('Històric Partits') }}
    </x-nav-link>
</div>
```


## Exercicis 

### 1. Ordenació de la BBDD, seeders i factories

- Anem a afegir els següents camps a la BBDD
  - Afegir el camp `data_naixement` a la taula `jugadores` de tipus `date`.
  - Afegir el camp `estadi_id` a la taula `partits` clau forània
  - Afegir el camp `arbitre_id` a la taula `partits` clau forània.
  - Afegir el camp `data` a la taula partits de tipus date.
  - Afegir el camp `dorsal` a la taula jugadores de tipus integer.
  - Afegir el camp `jornada` a la taula partits de tipus integer.
- Fes que el seeder de usuaris cree 30 amb el rol `arbitre`.
- Fes que el seeder de equips només en cree 18.
- Anem a crear el calendari utilitzant el chatgpt.  

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Equip;
use App\Models\Partit;
use App\Models\User;
use Carbon\Carbon;
use Exception;

class PartitsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $arbitres = User::where('role', 'arbitre')->get();

        if ($arbitres->isEmpty()) {
            throw new Exception('No hi ha cap àrbitre disponible.');
        }

        $equips = Equip::all();
        $numEquips = $equips->count();

        if ($numEquips % 2 !== 0 || $numEquips < 2) {
            throw new Exception('El nombre d\'equips ha de ser parell i almenys 2.');
        }

        $numJornades = $numEquips - 1; // Nombre de jornades per anada
        $partitsPerJornada = $numEquips / 2;
        $dataInicial = Carbon::create(2024, 9, 7); // Comença el 7 de setembre
        $dataLimitResultats = Carbon::create(2024, 12, 15); // Fins al 15 de desembre
        $arbitres = $arbitres->shuffle();

        // Generem el calendari d'anada
        $jornades = [];
        for ($jornada = 1; $jornada <= $numJornades; $jornada++) {
            $dataJornada = $dataInicial->copy()->addWeeks($jornada - 1); // Una jornada per setmana
            $jornades[$jornada] = []; // Guardem els partits d'aquesta jornada

            // Distribuïm els equips
            $equipsActuals = $equips->toArray();
            $localEquips = array_slice($equipsActuals, 0, $partitsPerJornada);
            $visitantEquips = array_reverse(array_slice($equipsActuals, $partitsPerJornada));

            for ($i = 0; $i < $partitsPerJornada; $i++) {
                $local = $localEquips[$i];
                $visitant = $visitantEquips[$i];

                // Alternança casa i fora
                if ($jornada % 2 === 0) { // Invertim en jornades parells
                    $temp = $local;
                    $local = $visitant;
                    $visitant = $temp;
                }

                $dataAleatoria = $dataJornada->copy()->addDays(rand(-2, 2)); // Data aleatòria dins del rang [-2, 2]
                $partit = Partit::create([
                    'local_id' => $local['id'],
                    'visitant_id' => $visitant['id'],
                    'estadi_id' => $local['estadi_id'],
                    'arbitre_id' => $arbitres->random()->id,
                    'jornada' => $jornada,
                    'data' => $dataAleatoria,
                    'gol_local' => $dataAleatoria < $dataLimitResultats ? rand(0, 5) :null,
                    'gol_visitant' => $dataAleatoria < $dataLimitResultats ? rand(0, 5) :null,
                ]);
                $jornades[$jornada][] = $partit;
            }

            // Rotació dels equips (round-robin)
            $equips->push($equips->splice(1, 1)[0]);
        }

        // Generem el calendari de tornada
        foreach ($jornades as $jornada => $partits) {
            $dataJornadaTornada = $dataInicial->copy()->addWeeks($numJornades + $jornada - 1); // Jornades de tornada després de les d'anada

            foreach ($partits as $partit) {
                $dataAleatoria = $dataJornadaTornada->copy()->addDays(rand(-2, 2)); // Data aleatòria dins del rang [-2, 2]
                Partit::create([
                    'local_id' => $partit->visitant_id, // Invertim local i visitant
                    'visitant_id' => $partit->local_id,
                    'estadi_id' => $partit->visitant_id ? Equip::find($partit->visitant_id)->estadi_id : null,
                    'arbitre_id' => $arbitres->random()->id,
                    'jornada' => $jornada + $numJornades, // Jornada de tornada
                    'data' => $dataAleatoria,
                    'gol_local' => $dataAleatoria < $dataLimitResultats ? rand(0, 5) : null,
                    'gol_visitant' => $dataAleatoria < $dataLimitResultats ? rand(0, 5) : null,
                ]);
            }
        }
    }
}

```

### 2. Creació dels Form Requests
 
- Genera els Form Requests per als models `Estadi`, `Jugadora` i `Partit` utilitzant Artisan.
- Implementa les regles de validació següents:
    - **Estadis**:
        - `nom`: Obligatori, text amb un màxim de 255 caràcters.
        - `capacitat`: Obligatori, número enter positiu.
        - `ciutat`: Obligatori, text amb un màxim de 255 caràcters.
    - **Jugadores**  :
        - `nom`: Obligatori, text amb un màxim de 255 caràcters.
        - `posició`: Obligatori, una de les opcions `defensa`, `migcampista`, `davantera` o `porter`.
        - `equip_id`: Obligatori, identificador existent a la taula `equips`.
        - `data_naixement`: Obligatori, data vàlida anterior a la data actual i de minim 16 anys.
        - `foto`: Opcional, pero si està ha de ser una foto .png i amb un tamany màxim.
    - **Partits**  :
        - `goles_local`: Obligatori, igual o major que 0.
        - `goles_visitant`: Obligatori, igual o major que 0.
         
         
- Substitueix la validació manual al controlador pels Form Requests creats.
- Personalitza els missatges d'error perquè siguen més clars per als usuaris.
- Si algun camp no està dona'l d'alta a les migracions, seeders i factories.
 
### 3. Restricció de les operaciones per als usuaris no autenticants

- Sabent que @auth @endauth son les directives per a autenticació, modifica les vistes per a que els usuaris no autenticats no vegen les operacions, ni en la columna en la taula.

### 4. Restricció de permisos per als partits

Assegurar que només els usuaris amb rol d'`àrbitre` puguin modificar partits. Ningú pot crear-ne.
 
- Modifica el Form Request de `Partit` per incloure una validació que només permeta accedir als usuaris amb rol d'`àrbitre`.
- Utilitza el mètode `authorize()` del Form Request per implementar aquesta restricció.
- Verifica que el middleware de rol ja implementat també assegure que només els àrbitres poden accedir a les rutes de  **modificació** de partits.
- Inhabilita les rutes de creació i esborrat de partits. 

### 5. Jugadores

- Assegurat que soles els manager puguen crear, modificar o esborrar a les seues jugadores.
- Així mateix quan un manager crea una jugadora aquesta ha de ser assignada al seu equip.
- Modifica el component de jugadora per poder vore-la en els equips de forma semblant. 


<figure style="align: center;">
    <img src="imagenes/09/equips.png" width="700">
    <figcaption>Exemple d'equip</figcaption>
</figure>
 

### 6. Calendari

- Crea una vista per a vore les jornades i el resultats dels partits.  
- Si l'usuari és un arbitre aleshores soles vora els seus partits i podrà modificar-los.

<figure style="align: center;">
    <img src="imagenes/09/jornada.png" width="700">
    <figcaption>Exemple de jornada</figcaption>
</figure>
 
### 7. Equips

- Crea un camp calculat per a vore l'edat mitjana de les jugadores de l'equip. 
- Fes que baix de les jugadores isquen els ultims 5 resultats jugats per l'equip.

### 8. Classificació

  
- Crea un component livewire per mostrar la classificació en temps real.

- Genera una taula que mostre, per a cada equip:
   - Nom de l’equip.
   - Total de punts.
   - Partits jugats.
   - Partits guanyats, empatats i perduts.
   - Gols a favor i en contra.
   - Diferència de gols.
   
- Ordena automàticament els equips per punts (i per diferència de gols en cas d’empat).
 
#### Condicionants 

1. Implementar la funcionalitat com a **component Livewire**.
2. Fer servir una combinació de **Eloquent** i càlculs personalitzats per generar la classificació.
3. Presentar el resultat en temps real.
4. Sense filtres ni opcions addicionals, simplement la taula de classificació actualitzada.

### 9. Proves
1. Crea proves per jugadoresController, EstadiController i PartitController.

### 10. Correu

1. Crea un correu per a enviar a tots els arbitres el seu calendari anual de partits.
