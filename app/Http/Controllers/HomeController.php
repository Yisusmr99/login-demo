<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        $results = DB::connection('oracle')->select('SELECT * FROM users@SQLSERVER_DBLINK'); // Cambia EMPLEADOS por alguna tabla que tengas        
        //dd($results); // Muestra los resultados de la consulta
       // $info = $results->sql;
	return view('home', compact('results'));
    }
}
