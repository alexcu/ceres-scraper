window.addEventListener("load", () => {
  document.querySelector("form#login").addEventListener("submit", (e) => {
    var username = e.srcElement.elements["email"].value
    var password = e.srcElement.elements["password"].value
    var authToken = window.btoa('ceres-front-end:ceres-is-awesome')
    var xhr = new XMLHttpRequest()
    xhr.open('POST', '/oauth/token')
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
    xhr.setRequestHeader('Authorization', `Basic ${authToken}`)
    xhr.onreadystatechange = () => {
      if (xhr.readyState > 3 && xhr.status == 200) {
        var res = JSON.parse(xhr.responseText)
        var now = new Date()
        sessionStorage.setItem('accessToken', res['access_token'])
        sessionStorage.setItem('expiresAt', now.setSeconds(now.getSeconds() + res['expires_in']))
      }
    }
    xhr.send(`grant_type=password&username=${username}&password=${password}`)
  })
})
