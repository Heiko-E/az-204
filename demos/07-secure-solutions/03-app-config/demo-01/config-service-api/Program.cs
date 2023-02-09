using System;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureAppConfiguration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

string connectionString = "Endpoint=https://foodconfig-dev.azconfig.io;Id=B1kS-l9-s0:O8WiC3kXo8OKaABKcK4y;Secret=dlCIR0ybMLVX1czEyI9AlaKOcVaINQbZZkkek8uKS88=";

builder.Configuration.AddAzureAppConfiguration(options =>
{    
    options.Connect(connectionString)
        .ConfigureKeyVault(kv =>
        {
            kv.SetCredential(new DefaultAzureCredential());
        })
        .Select("*", "production")        
        .ConfigureRefresh(refreshOptions =>
            refreshOptions.Register("Settings:Sentinel", refreshAll: true));
});

// Add services to the container.
// Configuration
IConfiguration Configuration = builder.Configuration;
builder.Services.AddSingleton<IConfiguration>(Configuration);
var cfg = Configuration.Get<AppConfig>();

// Key Vault Client
var client = new SecretClient(new Uri($"https://{cfg.AppSettings.KeyVault}"), new DefaultAzureCredential());
builder.Services.AddSingleton<SecretClient>(client);

builder.Services.AddControllers();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "App-Config-Api", Version = "v1" });
});

// Cors
builder.Services.AddCors(o => o.AddPolicy("nocors", builder =>
{
    builder
        .SetIsOriginAllowed(host => true)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
}));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

// Swagger
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "App-Config-Service-Api");
    c.RoutePrefix = string.Empty;
});

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
