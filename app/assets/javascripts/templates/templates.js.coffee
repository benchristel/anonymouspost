angular.module('AnonymousApp').run [
  "$templateCache"
  ($templateCache) ->
    $templateCache.put "/dialogs/login.html", """
    <div class="modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title"> Log In </h4>
          </div>
            <div class="modal-body">
              <ng-form name="nameDialog" novalidate role="form">
              <div class="form-group input-group-lg" ng-class="{true: 'has-error'}[nameDialog.username.$dirty && nameDialog.username.$invalid]">
                <label class="control-label" for="username">Name:</label>
                <input type="text" class="form-control" placeholder="username" name="username" id="username" ng-model="user.name" ng-keyup="hitEnter($event)" required>
                <input type="password" class="form-control" name="password" placeholder="password" id="password" ng-model="user.password" ng-keyup="hitEnter($event)" required>
                <span class="help-block"> Log in to your existing account</span>
              </div>
              </ng-form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" ng-click="cancel()">Cancel</button>
            <button type="button" class="btn btn-primary" ng-click="save()" ng-disabled="(nameDialog.$dirty && nameDialog.$invalid) || nameDialog.$pristine">Save</button>
            </div>
          </div>
        </div>
      </div>"""
    $templateCache.put "/dialogs/signup.html", """
    <div class="modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title"> Sign Up </h4>
          </div>
            <div class="modal-body">
              <ng-form name="nameDialog" novalidate role="form">
              <div class="form-group input-group-lg" ng-class="{true: 'has-error'}[nameDialog.username.$dirty && nameDialog.username.$invalid]">
                <label class="control-label" for="username">Name:</label>
                <input type="text" class="form-control" placeholder="username" name="username" id="username" ng-model="user.name" ng-keyup="hitEnter($event)" required>
                <input type="password" class="form-control" name="password" placeholder="password" id="password" ng-model="user.password" ng-keyup="hitEnter($event)" required>
                <span class="help-block"> Create an account </span>
              </div>
              </ng-form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" ng-click="cancel()">Cancel</button>
            <button type="button" class="btn btn-primary" ng-click="save()" ng-disabled="(nameDialog.$dirty && nameDialog.$invalid) || nameDialog.$pristine">Save</button>
            </div>
          </div>
        </div>
      </div>"""
    $templateCache.put "/dialogs/post.html", """<div class="modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title"> New Post </h4>
          </div>
            <div class="modal-body">
              <ng-form name="postDialog" novalidate role="form">
              <div class="form-group input-group-lg" ng-class="{true: 'has-error'}[postDialog.post.$dirty && postDialog.post.$invalid]">
                <textarea class="form-control" placeholder="You're shitty post." name="post" id="post" ng-model="user.post" required></textarea>
                <span class="help-block"> Create an account </span>
              </div>
              </ng-form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" ng-click="cancel()">Cancel</button>
            <button type="button" class="btn btn-primary" ng-click="save()" ng-disabled="(postDialog.$dirty && postDialog.$invalid) || postDialog.$pristine">Save</button>
            </div>
          </div>
        </div>
      </div>"""
]
