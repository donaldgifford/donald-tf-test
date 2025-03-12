function(boilerplateVars) {
  MyTeam: [
    {
      name: sd.name,
      AWSAccountID: sd.AWSAccountID,
      Roles: sd.Roles,
    }
    for sd in boilerplateVars.MyTeam
  ]
}
