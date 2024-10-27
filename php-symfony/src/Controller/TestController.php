<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;

class TestController extends AbstractController
{
    #[Route('/test', name: 'app_test')]
    public function index(): JsonResponse
    {
        $user = $this->getUser();
        return $this->json(
            [
                'message' => "Symfony app was called from {$user->getName()} ({$user->getEmail()})",
                'path' => 'src/Controller/TestController.php',
            ]);
    }
}
