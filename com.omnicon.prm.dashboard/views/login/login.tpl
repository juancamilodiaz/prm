<div class="container">
   <div class="row vertical-offset-75">
      <div class="col-md-6 col-md-offset-3">
         <div class="panel panel-default">
            <div class="panel-heading text-center">
               <h3 class="panel-title"><strong>Login</strong></h3>
            </div>
            <div class="panel-body">
               <form accept-charset="utf-8" role="form" class="form-horizontal" method="POST" action='{{urlfor "LoginController.Login"}}'>
                  {{ .xsrfdata }}
                  {{template "alert.tpl" .}}
                  <div class="form-group">
                     <label for="inputEmail" class="col-sm-3 control-label">Email Address</label>
                     <div class="col-sm-9">
                        <input class="form-control" placeholder="ex: firstname.lastname@omnicon.cc" name="Email" value='{{index .Params "Email"}}' type="email" required 
                           id="inputEmail" />
                     </div>
                  </div>
                  <div class="form-group">
                     <label for="inputPassword" class="col-sm-3 control-label">Password</label>
                     <div class="col-sm-9">
                        <input class="form-control" placeholder="Enter the password" name="Password" type="password" value="" required 
                           pattern=".{6,}" title="La contraseña debe tener al menos 6 caracteres" id="inputPassword"  />
                     </div>
                  </div>
                  <div class="form-group">
                     <div class="col-sm-12">
						<button type="submit" class="btn btn-lg btn-primary pull-right">
							<span class="glyphicon glyphicon-log-in"></span> Sign in
						</button>
                     </div>
                     <div class="col-sm-12">
						<a class="pull-right" href='{{urlfor "LoginController.PasswordReset"}}'> 
                        Forgot your password »
                        </a>
                     </div>
                  </div>
               </form>
            </div>
            <div class="panel-footer text-center clearfix">If you do not have an account <a href='{{urlfor "LoginController.Signup"}}'>New register »</a></div>
         </div>
      </div>
   </div>
</div>