@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">{{ __('Dashboard') }}</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    {{ __('Estas conectado!') }} <br>
		            SQL ejecutado: <strong> {{ $consultaSql}} </strong> <br>
                    <table class="table table-striped mt-4">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre usuario</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($results as $key => $result)
                                <tr>
                                    <td>{{ $result->id }}</td>
                                    <td>{{ $result->name }}</td>
				                    <td>{{ $result->email }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
