<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class DebugController extends AbstractController
{
    #[Route('/debug', name: 'app_debug')]
    public function index(): JsonResponse
    {
        phpinfo();

        return $this->json([]);
    }
}
