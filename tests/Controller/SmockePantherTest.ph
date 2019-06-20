<?php

namespace App\Tests;

use Symfony\Component\Panther\PantherTestCase;

class UserActionsTest extends PantherTestCase
{
    /**
     * Un utilisateur peut s'inscrire sur le Blog
     */
    public function testRegistration()
    {
        $client = static::createPantherClient();
        $crawler = $client->request('GET', '/inscription');

        # Ce formulaire est généré en Javascript
        $client->waitFor('#inscription-form');
        
        # Soumission du formulaire
        $client->submitForm('Créer le compte', [
            'username' => 'zozor',
            'password' => 'Zoz0rIsHome',
        ]);
       
        # Redirection de l'utilisateur nouvellement inscrit vers l'accueil
        $this->assertSame(self::$baseUri.'/', $client->getCurrentURL());
        
        # Notification de succès en Javascript
        $client->waitFor('#success-message');
        $this->assertSame('Bienvenue sur le blog Zozor', $crawler->filter('#success-message ol li:first-child')->text());
        
        # L'utilisateur est bien authentifié
        $this->assertSame('Zozor', $crawler->filter('#user-profile span:first-child')->text());
    }
}